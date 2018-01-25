class AddAttachmentImageToGalleryPics < ActiveRecord::Migration
  def self.up
    change_table :gallery_pics do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :gallery_pics, :image
  end
end
