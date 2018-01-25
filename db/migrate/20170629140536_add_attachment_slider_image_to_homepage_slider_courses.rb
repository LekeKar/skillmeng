class AddAttachmentSliderImageToHomepageSliderCourses < ActiveRecord::Migration
  def self.up
    change_table :homepage_slider_courses do |t|
      t.attachment :slider_image
    end
  end

  def self.down
    remove_attachment :homepage_slider_courses, :slider_image
  end
end
