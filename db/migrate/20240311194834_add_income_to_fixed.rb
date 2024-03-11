class AddIncomeToFixed < ActiveRecord::Migration[7.1]
  def change
    add_column :fixeds, :income, :boolean
    add_column :fixeds, :title, :string
    add_column :fixeds, :start_date, :datetime
  end
end
