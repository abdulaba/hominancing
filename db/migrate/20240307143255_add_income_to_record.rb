class AddIncomeToRecord < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :income, :boolean
  end
end
