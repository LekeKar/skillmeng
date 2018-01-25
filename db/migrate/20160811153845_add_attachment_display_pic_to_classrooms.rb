class AddAttachmentDisplayPicToClassrooms < ActiveRecord::Migration
  def self.up
    change_table :classrooms do |t|
      t.attachment :display_pic
    end
  end

  def self.down
    remove_attachment :classrooms, :display_pic
  end
end
