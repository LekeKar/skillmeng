class AddPrimaryToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :primary, :boolean, :default => false
  end
end
