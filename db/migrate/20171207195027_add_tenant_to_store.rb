class AddTenantToStore < ActiveRecord::Migration[5.1]
  def change
    add_reference :stores, :spree_tenant, foreign_key: true
  end
end
