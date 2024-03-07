class AddColorToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :color, :string
  end
end
