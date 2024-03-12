class AddColumnnsToPlan < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :status, :boolean
    add_column :plans, :balance, :float
  end
end
