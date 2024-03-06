class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.float :amount
      t.string :category
      t.string :note
      t.references :account, null: false, foreign_key: true
      t.references :plan, null: true, foreign_key: true

      t.timestamps
    end
  end
end
