class AddVideoToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :video, :string
  end
end
