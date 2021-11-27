class AddmanualsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :manuals, :string
  end
end
