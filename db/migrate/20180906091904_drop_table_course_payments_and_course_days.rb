class DropTableCoursePaymentsAndCourseDays < ActiveRecord::Migration
  def change
    drop_table :course_days, force: :cascade
  end
end
