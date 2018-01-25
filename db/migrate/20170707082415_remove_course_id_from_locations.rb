class RemoveCourseIdFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :course_id
  end
end
