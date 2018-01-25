class AddAndysPickAndFeaturedToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :andys_pick, :boolean, :default => false 
    add_column :courses, :featured, :boolean, :default => false 
  end
end
