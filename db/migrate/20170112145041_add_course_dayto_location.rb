class AddCourseDaytoLocation < ActiveRecord::Migration
  def change
    add_column :locations, :course_day_id, :integer
    add_index :locations, :course_day_id
    
    remove_column :course_days, :location_id, :integer
  end
end
