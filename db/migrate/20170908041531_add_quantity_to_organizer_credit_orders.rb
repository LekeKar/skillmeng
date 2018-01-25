class AddQuantityToOrganizerCreditOrders < ActiveRecord::Migration
  def change
    add_column :organizer_credit_orders, :quantity, :integer
  end
end
