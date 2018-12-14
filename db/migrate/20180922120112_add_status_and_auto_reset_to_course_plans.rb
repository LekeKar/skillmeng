class AddStatusAndAutoResetToCoursePlans < ActiveRecord::Migration[5.0]
  def change
    add_column :course_plans, :status, :string, default: "Open"
    add_column :course_plans, :auto_reset, :string, default: "Never"
    add_column :course_plans, :slug, :string
    add_index :course_plans, :slug, unique: true
    
  end
end