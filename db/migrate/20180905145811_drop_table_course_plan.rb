class DropTableCoursePlan < ActiveRecord::Migration
  def change
    drop_table :course_plan, force: :cascade
  end
end
