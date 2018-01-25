class AddJobTitleToCourseTutor < ActiveRecord::Migration
  def change
    add_column :course_tutors, :job_title, :string
  end
end
