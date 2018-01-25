class RenameClassroomstoCourses < ActiveRecord::Migration
  def change
    rename_table :classrooms, :courses
  end
end
