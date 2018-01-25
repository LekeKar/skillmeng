class AddLocationIdToCourseTime < ActiveRecord::Migration
  def change
    add_column :course_times, :location_id, :integer
    add_index :course_times, :location_id
  end
end
