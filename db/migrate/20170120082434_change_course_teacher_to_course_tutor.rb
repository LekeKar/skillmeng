class ChangeCourseTeacherToCourseTutor < ActiveRecord::Migration
  def change
    rename_table :course_teachers, :course_tutors
  end
end
