class ChangePricesToFloat < ActiveRecord::Migration
  def change
    change_column :organizer_credit_orders, :price, :float, default: 7.5
    change_column :course_promotions, :price, :float, default: 7500
    change_column :organizer_orders, :total, :float
  end
end
