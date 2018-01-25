class AddSubscribeToFavoriteCourse < ActiveRecord::Migration
  def change
    add_column :favorite_courses, :subscribe, :boolean, :default => true 
  end
end
