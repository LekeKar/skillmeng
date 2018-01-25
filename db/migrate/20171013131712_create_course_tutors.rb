class CreateCourseTutors < ActiveRecord::Migration
  def change
    create_table :course_tutors do |t|
      t.references :course, index: true, foreign_key: true
      t.references :tutor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
