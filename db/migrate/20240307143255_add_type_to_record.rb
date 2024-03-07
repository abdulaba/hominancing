class AddTypeToRecord < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :type, :boolean
  end
end
