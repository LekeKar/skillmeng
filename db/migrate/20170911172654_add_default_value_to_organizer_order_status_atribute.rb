class AddDefaultValueToOrganizerOrderStatusAtribute < ActiveRecord::Migration
  def change
    change_column :organizer_orders, :status, :string, default: "awaiting payment"
  end
end
