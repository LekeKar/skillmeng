class AddOrderNumberToOrganizerOrder < ActiveRecord::Migration
  def change
    add_column :organizer_orders, :order_number, :string
  end
end
