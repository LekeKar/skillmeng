json.extract! course_day, :id, :week_day, :calender_day, :course_id, :created_at, :updated_at
json.url course_time_url(course_day, format: :json)