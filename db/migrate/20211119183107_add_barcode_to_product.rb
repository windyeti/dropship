class AddBarcodeToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :barcode, :string
    add_column :products, :cat2, :string
    add_column :products, :cat3, :string
    add_column :products, :cat4, :string
    add_column :products, :cat5, :string
  end
end
