class AddIncomeToFixed < ActiveRecord::Migration[7.1]
  def change
    add_column :fixeds, :income, :boolean
    add_column :fixeds, :title, :string
  end
end
