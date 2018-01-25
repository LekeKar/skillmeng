class AddAttendedByToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :attended_by, :string
  end
end
