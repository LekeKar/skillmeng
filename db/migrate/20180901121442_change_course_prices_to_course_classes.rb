class ChangeCoursePricesToCourseClasses < ActiveRecord::Migration
  def change
    add_column :course_prices, :description, :text
    add_column :course_prices, :trade_by_barter, :boolean, default: false
    rename_column :course_prices, :unit, :plan_name
    rename_column :course_prices, :explaination, :refund_policy
    rename_column :course_prices, :quantity, :capacity
    rename_column :course_prices, :course_payment_id, :course_id
    rename_table :course_prices, :course_plan
  end
end


