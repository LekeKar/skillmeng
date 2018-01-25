class AddBroadcastToCourseNotifications < ActiveRecord::Migration
  def change
    add_column :course_notifications, :broadcast, :boolean
  end
end
