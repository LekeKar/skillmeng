class RemoveForeignKeyFromOrderItem < ActiveRecord::Migration
  def change
    #removing freign key
    remove_column :order_items, :course_price_id
    
    add_column :order_items, :course_price_id, :integer
  end
end
