class AddImportantToCourseNotifications < ActiveRecord::Migration
  def change
    add_column :course_notifications, :important, :boolean, :default => false
  end
end
