require 'rake'

class StoreCreationJob < ApplicationJob
  queue_as :default

  def perform(**args)
    # Do something later
    store = args.fetch(:store)
    #name = args.fetch(:name)
    name = store.subdomain
    admin_email = args.fetch(:admin_email)
    password = args.fetch(:password)

    puts "Creating store #{name}"
    spree_tenant = create_store(name, admin_email, password)

    store.tenant = spree_tenant
    store.save

    
end

private

def create_store(name, admin_email, password)

  tenant = name.gsub('-', '_') 
  spree_tenant = Spree::Tenant.create name: tenant
  Apartment::Tenant.create tenant

  puts 'Store created successfully'
  ENV['RAILS_CACHE_ID'] = tenant

  Apartment::Tenant.switch(tenant) do
    # Hack the current method so we're able to return a gateway
    # without a RAILS_ENV
    Spree::Gateway.class_eval do
      def self.current
        Spree::Gateway::Bogus.new
      end
    end

    #Rake::Task['db:seed'].invoke
    #Rails.application.load_seed
    Rails.application.load_tasks
     Rake::Task['db:seed'].invoke
    puts "Creating admin user #{admin_email}"
    create_admin_user(name, admin_email, password)
  end
  spree_tenant
end

def create_admin_user(tenant, email, password)
  attributes = {
    password: password,
    password_confirmation: password,
    email: email,
    login: email
  }
  if Spree::User.find_by_email(email)
    raise "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake spree_auth:admin:create again with a different email.\n\n"
  else
    admin = Spree::User.new(attributes)
    if admin.save
      role = Spree::Role.find_or_create_by(name: 'admin')
      admin.spree_roles << role
      admin.save
      admin.generate_spree_api_key! if Spree::Auth::Engine.api_available?
    else
      raise "There was some problems with persisting new admin user:"
      admin.errors.full_messages.each do |error|
        raise error
      end
    end
  end

end

end
