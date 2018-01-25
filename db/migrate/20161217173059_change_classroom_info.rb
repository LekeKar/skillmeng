class ChangeClassroomInfo < ActiveRecord::Migration
  def change
    remove_column :classrooms, :price
    rename_column :classrooms, :frequency, :skill_level
    rename_column :classrooms, :activate, :state
    change_column :classrooms, :state, :string
  end
end
