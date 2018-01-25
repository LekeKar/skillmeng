class AddScheduleStyleToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :schedule_style, :string
    add_column :course_prices, :quantity, :integer
    rename_column :course_prices, :for, :unit
  end
end
