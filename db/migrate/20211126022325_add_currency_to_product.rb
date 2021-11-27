class AddCurrencyToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :currency, :string
  end
end
