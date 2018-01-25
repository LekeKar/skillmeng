class AddPaystackPlanToClassPayments < ActiveRecord::Migration
  def change
    add_column :class_payments, :paystack_plan, :string
    
  end
end
