class AddColumnsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :attendee_name, :string
    add_column :order_items, :attendee_tel, :string
    add_column :order_items, :attendace_type, :string
    add_column :order_items, :attenace_left, :integer
    add_column :order_items, :end_time, :datetime
    add_column :order_items, :status, :boolean, default: true
    add_column :order_items, :plan_price, :integer
    add_column :order_items, :plan_quantity, :integer
    add_column :order_items, :plan_unit, :string
  end
end
