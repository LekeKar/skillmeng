class CreateHomepageSliderCourses < ActiveRecord::Migration
  def change
    create_table :homepage_slider_courses do |t|
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
