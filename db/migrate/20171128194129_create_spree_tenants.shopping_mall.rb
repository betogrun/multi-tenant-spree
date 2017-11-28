# This migration comes from shopping_mall (originally 20150901171448)
class CreateSpreeTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_tenants do |t|
      t.string :name

      t.timestamps null: false
    end

    add_index :spree_tenants, :name
  end
end
