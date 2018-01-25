class ChangeClassroomIdToCourseId < ActiveRecord::Migration
  def change
    rename_column :abouts, :classroom_id, :course_id
    rename_column :contacts, :classroom_id, :course_id
    rename_column :course_payments, :classroom_id, :course_id
    rename_column :course_requests, :classroom_id, :course_id
    rename_column :favorite_courses, :classroom_id, :course_id
    rename_column :gallery_pics, :classroom_id, :course_id
    rename_column :lessons, :classroom_id, :course_id
    rename_column :locations, :classroom_id, :course_id
    rename_column :reports, :classroom_id, :course_id
    rename_column :reviews, :classroom_id, :course_id
    rename_column :schedules, :classroom_id, :course_id
    rename_column :transactions, :classroom_id, :course_id
  end
end
