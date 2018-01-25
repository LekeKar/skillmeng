class CreateCourseTeachers < ActiveRecord::Migration
  def change
    create_table :course_teachers do |t|
      t.string :name
      t.text :bio
      t.string :website

      t.timestamps null: false
    end
  end
end
