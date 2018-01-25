class ChangeCourseIdToCoursePaymentId < ActiveRecord::Migration
  def change
    rename_column :course_prices, :course_id, :course_payment_id
  end
end
