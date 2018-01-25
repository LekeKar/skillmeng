class ChangeCourseIdToOrganizerId < ActiveRecord::Migration
  def change
    rename_column :tutors, :course_id, :organizer_id
  end
end
