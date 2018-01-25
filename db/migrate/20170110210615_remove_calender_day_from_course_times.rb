class RemoveCalenderDayFromCourseTimes < ActiveRecord::Migration
  def change
    remove_column :course_times, :calender_day, :date
    rename_column :course_times, :week_day, :description
  end
end
