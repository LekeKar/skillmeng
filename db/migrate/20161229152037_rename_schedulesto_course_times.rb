class RenameSchedulestoCourseTimes < ActiveRecord::Migration
  def change
    rename_table :schedules, :course_times
  end
end
