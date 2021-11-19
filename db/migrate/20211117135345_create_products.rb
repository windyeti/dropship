class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :fid
      t.string :title
      t.string :url
      t.string :sku
      t.string :distributor
      t.string :image
      t.string :cat
      t.string :cat1
      t.string :cat2
      t.string :cat3
      t.string :cat4
      t.string :cat5
      t.string :barcode
      t.decimal :price
      t.integer :quantity
      t.string :p1
      t.string :desc
      t.bigint :insales_id
      t.bigint :insales_var_id
      t.boolean :check, default: true

      t.timestamps
    end
  end
end
