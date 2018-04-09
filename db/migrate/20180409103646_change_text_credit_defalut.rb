class ChangeTextCreditDefalut < ActiveRecord::Migration
  def change
    change_column :organizer_credit_orders, :text_price, :float, default: 11.99
  end
end
