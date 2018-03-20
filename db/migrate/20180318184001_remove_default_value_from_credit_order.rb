class RemoveDefaultValueFromCreditOrder < ActiveRecord::Migration
  def change
     change_column :organizer_credit_orders, :email_quantity, :integer
    change_column :organizer_credit_orders, :text_quantity, :integer
  end
end
