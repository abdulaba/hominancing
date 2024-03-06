class CreateFixeds < ActiveRecord::Migration[7.1]
  def change
    create_table :fixeds do |t|
      t.integer :periodicity
      t.float :amount
      t.string :category
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
