class RemoveCourseIdFromOrganizers < ActiveRecord::Migration
  def change
    remove_column :organizers, :course_id
  end
end
