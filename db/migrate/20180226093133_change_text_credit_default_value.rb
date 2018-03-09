class ChangeTextCreditDefaultValue < ActiveRecord::Migration
  def change
    change_column :organizer_credit_orders, :text_price, :float, default: 29.50
  end
end
