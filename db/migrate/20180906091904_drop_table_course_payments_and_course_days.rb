class DropTableCoursePaymentsAndCourseDays < ActiveRecord::Migration
  def change
    drop_table :course_days, force: :cascade
    drop_table :course_payments, force: :cascade
  end
end
