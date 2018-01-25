class DropCoursePrice < ActiveRecord::Migration
  def change
    drop_table :course_prices
  end
end
