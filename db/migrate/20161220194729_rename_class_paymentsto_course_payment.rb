class RenameClassPaymentstoCoursePayment < ActiveRecord::Migration
  def change
    rename_table :class_requests, :course_requests
    rename_table :class_payments, :course_payments
  end
end
