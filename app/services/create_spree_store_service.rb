require 'rake'

class CreateSpreeStoreService

  def initialize(params={})
    @store = params.fetch(:store)
    @admin_email = params.fetch(:admin_email)
    @admin_password = params.fetch(:admin_password)
  end

  def perform
    create_spree_store
  end

  private 

  def create_spree_store
    @store.tap do |s|
      s.tenant = create_spree_tenant
      s.save
    end
    
  end

  def create_spree_tenant
    tenant = @store.subdomain.gsub('-', '_') 
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
      puts "Creating admin user #{@admin_email}"
      create_admin_user
    end
    spree_tenant
  end

  def create_admin_user
    attributes = {
      password: @admin_password,
      password_confirmation: @admin_password,
      email: @admin_email,
      login: @admin_email
    }
    if Spree::User.find_by_email(@admin_email)
      raise "\nWARNING: There is already a user with the email: #{@admin_mail}, so no account changes were made.  If you wish to create an additional admin user, please run rake spree_auth:admin:create again with a different email.\n\n"
    else
      admin = Spree::User.new(attributes)
      if admin.save
        role = Spree::Role.find_or_create_by(name: 'admin')
        admin.spree_roles << role
        admin.save
        admin.generate_spree_api_key! if Spree::Auth::Engine.api_available?
      else
        #raise "There was some problems with persisting new admin user:"
        admin.errors.full_messages.each do |error|
          raise error
        end
      end
    end

  end
end