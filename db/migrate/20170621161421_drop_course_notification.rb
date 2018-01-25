class DropCourseNotification < ActiveRecord::Migration
  def change
    drop_table :course_notifications
  end
end
