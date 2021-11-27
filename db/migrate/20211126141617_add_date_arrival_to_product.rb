class AddDateArrivalToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :date_arrival, :string
  end
end
