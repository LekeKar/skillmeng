class AddDefaultValueToCreditOrder < ActiveRecord::Migration
  def change
    change_column :organizer_credit_orders, :email_quantity, :integer, default: 0
    change_column :organizer_credit_orders, :text_quantity, :integer, default: 0
  end
end
