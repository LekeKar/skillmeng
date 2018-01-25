class ChangeForToUnitInCoursePrices < ActiveRecord::Migration
  def change
     rename_column :course_prices, :for, :unit
     add_column :course_prices, :quantity, :integer
  end
end
