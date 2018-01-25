class CreateCourseDays < ActiveRecord::Migration
  def change
    create_table :course_days do |t|
      t.string :weekday
      t.date :calendar_day
      t.references :course, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
