class RenameFavoriteClassroomstoFavoriteCourses < ActiveRecord::Migration
  def change
    rename_table :favorite_classrooms, :favorite_courses
  end
end
