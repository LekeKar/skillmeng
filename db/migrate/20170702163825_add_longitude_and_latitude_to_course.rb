class AddLongitudeAndLatitudeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :longitude, :float
    add_column :courses, :latitude, :float
  end
end
