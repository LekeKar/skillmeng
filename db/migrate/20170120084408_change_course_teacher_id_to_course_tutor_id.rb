class ChangeCourseTeacherIdToCourseTutorId < ActiveRecord::Migration
  def change
    rename_column :qualifications, :course_teacher_id, :course_tutor_id
  end
end
