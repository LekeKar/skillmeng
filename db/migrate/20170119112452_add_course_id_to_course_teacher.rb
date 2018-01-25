class AddCourseIdToCourseTeacher < ActiveRecord::Migration
  def change
    add_column :course_teachers, :course_id, :integer
    add_index :course_teachers, :course_id
  end
end
