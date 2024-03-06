class CreateAcounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.float :balance
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
