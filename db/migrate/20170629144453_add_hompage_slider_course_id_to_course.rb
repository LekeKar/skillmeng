class AddHompageSliderCourseIdToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :homepage_slider_course_id, :integer
  end
end
