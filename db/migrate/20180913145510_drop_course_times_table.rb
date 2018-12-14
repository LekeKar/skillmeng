class DropCourseTimesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :course_times, force: :cascade
  end
end
