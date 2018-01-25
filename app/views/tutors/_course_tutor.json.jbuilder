json.extract! course_teacher, :id, :name, :bio, :website, :created_at, :updated_at
json.url course_teacher_url(course_teacher, format: :json)