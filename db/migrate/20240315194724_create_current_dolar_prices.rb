class CreateCurrentDolarPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :current_dolar_prices do |t|
      t.float :price
      t.float :old_price

      t.timestamps
    end
  end
end
