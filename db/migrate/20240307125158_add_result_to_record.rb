class AddResultToRecord < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :result, :float
  end
end
