class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.float :amount
      t.string :category, default: 0
      t.string :note
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
