class SetDefaultValueForCourseRequest < ActiveRecord::Migration
  def change
    change_column :course_requests, :owner_read, :boolean, :default => false
  end
end
