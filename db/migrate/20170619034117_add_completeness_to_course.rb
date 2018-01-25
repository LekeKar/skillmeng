class AddCompletenessToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :completeness, :integer
  end
end
