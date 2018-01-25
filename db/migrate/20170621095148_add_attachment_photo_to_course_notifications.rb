class AddAttachmentPhotoToCourseNotifications < ActiveRecord::Migration
  def self.up
    change_table :course_notifications do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :course_notifications, :photo
  end
end
