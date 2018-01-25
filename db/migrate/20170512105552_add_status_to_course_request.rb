class AddStatusToCourseRequest < ActiveRecord::Migration
  def change
    add_column :course_requests, :status, :string, :default => "new" 
  end
end
