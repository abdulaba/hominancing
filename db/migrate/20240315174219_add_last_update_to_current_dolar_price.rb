class AddLastUpdateToCurrentDolarPrice < ActiveRecord::Migration[7.1]
  def change
    add_column :current_dolar_prices, :last_update, :date
  end
end
