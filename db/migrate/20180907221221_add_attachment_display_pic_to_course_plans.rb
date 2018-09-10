class AddAttachmentDisplayPicToCoursePlans < ActiveRecord::Migration
  def self.up
    change_table :course_plans do |t|
      t.attachment :display_pic
    end
  end

  def self.down
    remove_attachment :course_plans, :display_pic
  end
end
