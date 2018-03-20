class AddDefaultValueToPrice < ActiveRecord::Migration
  def change
     change_column :course_prices, :price, :decimal, default: 0
  end
end
