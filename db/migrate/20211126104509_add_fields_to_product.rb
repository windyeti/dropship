class AddFieldsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :manual, :string
    add_column :products, :preview_3d, :string
    add_column :products, :foto, :string
    add_column :products, :draft, :string
    add_column :products, :model_3d, :string
  end
end
