class RenameCourseState < ActiveRecord::Migration
  def change
    rename_column :courses, :state, :course_state
  end
end
