class ChangeCoursePaymentToOrgBankInfo < ActiveRecord::Migration
  def change
    remove_column :course_payments, :seek_course1
    remove_column :course_payments, :seek_course2
    remove_column :course_payments, :seek_course3
    remove_column :course_payments, :payment_instruction
    remove_column :course_payments, :refund_instruction
    remove_column :course_payments, :trade_by_barter
    rename_column :course_payments, :course_id, :organizer_id
    rename_table :course_payments, :org_bank_info
  end
end
