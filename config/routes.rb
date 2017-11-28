class SubdomainConstraint
  def self.matches?(request)
    subdomains = %w{ www admin }
    request.subdomain.present? && !subdomains.include?(request.subdomain)
  end
end

class GlobalContraint 
  def self.matches?(request)
    !request.subdomain.present?
  end
end

Rails.application.routes.draw do
=begin
  resources :stores
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/spree'
  devise_for :sellers
  root to: redirect('/stores')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
=end
  constraints GlobalContraint do
    devise_for :sellers
    resources :stores
    root to: redirect('/stores')
  end

  constraints SubdomainConstraint do
    mount Spree::Core::Engine, at: '/'
  end
end
