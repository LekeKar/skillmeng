class AddAttachmentPhotoToAnnouncements < ActiveRecord::Migration
  def self.up
    change_table :announcements do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :announcements, :photo
  end
end
