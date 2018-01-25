class AddBroadcastToFavoriteCourse < ActiveRecord::Migration
  def change
    add_column :favorite_courses, :broadcast, :boolean, :default => true 
  end
end
