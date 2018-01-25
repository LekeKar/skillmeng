class AddPaymentInstructionToCoursePayment < ActiveRecord::Migration
  def change
    add_column :course_payments, :payment_instruction, :text
  end
end
