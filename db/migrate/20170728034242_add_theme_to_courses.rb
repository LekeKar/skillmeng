class AddThemeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :theme, :string, :default => "flame_pea_orange" 
  end
end
