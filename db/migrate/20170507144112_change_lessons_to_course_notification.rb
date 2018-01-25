class ChangeLessonsToCourseNotification < ActiveRecord::Migration
  def change
    rename_table :lessons, :course_notifications
  end
end
