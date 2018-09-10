class AddScheduleToCoursePlans < ActiveRecord::Migration
  def change
    add_column :course_plans, :start_date, :date
    add_column :course_plans, :end_date, :date
    add_column :course_plans, :week_days, :text,  array: true, default: []
  end
end