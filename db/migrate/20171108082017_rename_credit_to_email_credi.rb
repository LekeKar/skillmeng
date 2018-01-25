class RenameCreditToEmailCredi < ActiveRecord::Migration
  def change
    rename_column :organizer_credit_orders, :quantity, :email_quantity
    rename_column :organizer_credit_orders, :price, :email_price
    rename_column :organizer_credit_bals, :regular, :email_regular
    rename_column :organizer_credit_bals, :bonus, :email_bonus
  end
end
