class AddColorAndDateToPlana < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :color, :string
    add_column :plans, :date, :datetime
  end
end
