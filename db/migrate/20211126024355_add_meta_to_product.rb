class AddMetaToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :mtitle, :string
    add_column :products, :mdesc, :string
    add_column :products, :mkeywords, :string
  end
end
