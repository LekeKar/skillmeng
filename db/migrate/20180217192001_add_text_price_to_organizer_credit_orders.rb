class AddTextPriceToOrganizerCreditOrders < ActiveRecord::Migration
  def change
    add_column :organizer_credit_orders, :text_price, :float, default: 30
    add_column :organizer_credit_orders, :text_quantity, :integer
  end
end
