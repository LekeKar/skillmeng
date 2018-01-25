class RenameCourseTutorIdToTutorId < ActiveRecord::Migration
  def change
    rename_column :qualifications, :course_tutor_id, :tutor_id
    rename_column :social_links, :course_tutor_id, :tutor_id
  end
end
