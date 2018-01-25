class RemoveSkillLevelFromClassroom < ActiveRecord::Migration
  def change
    remove_column :classrooms, :skill_level
  end
end
