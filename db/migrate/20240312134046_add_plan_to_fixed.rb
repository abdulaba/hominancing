class AddPlanToFixed < ActiveRecord::Migration[7.1]
  def change
    add_reference :fixeds, :plan, null: true, foreign_key: true
  end
end
