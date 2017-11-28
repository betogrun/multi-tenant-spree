class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string :subdomain
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end
