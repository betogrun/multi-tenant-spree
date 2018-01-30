class Store < ApplicationRecord
  belongs_to :seller
  belongs_to :tenant, class_name: "Spree::Tenant", foreign_key: "spree_tenant_id", optional: true

  validates :subdomain, uniqueness: true

end
