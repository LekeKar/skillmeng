class FixCashInstruction < ActiveRecord::Migration
  def change
  	 rename_column :class_payments, :cash_instruction, :refund_instruction
  	 rename_column :class_payments, :bank_instruction, :paystack_id
  	 change_column :class_payments, :paystack_id,  :string
  end
end
