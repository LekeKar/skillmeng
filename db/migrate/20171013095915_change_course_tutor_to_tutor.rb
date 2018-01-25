class ChangeCourseTutorToTutor < ActiveRecord::Migration
  def change
    rename_table :course_tutors, :tutors
  end
end
