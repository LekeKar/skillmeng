class CreateCoursePlan < ActiveRecord::Migration
  def change
    create_table :course_plans do |t|
      t.decimal :price , default: 0.0
      t.string :plan_name
      t.string :refund_policy, default: "No Refunds"
      t.integer :course_id
      t.integer :capacity
      t.text :description
      t.boolean :trade_by_barter, default: false
    end
  end
end
