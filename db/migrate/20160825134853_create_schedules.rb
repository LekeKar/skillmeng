class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.time :end_time
      t.time :start_time
      t.string :week_day
      t.date :calender_day
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
