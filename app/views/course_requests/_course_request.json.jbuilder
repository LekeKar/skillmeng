json.extract! course_request, :id, :sender_name, :sender_email, :sender_phone, :additional_info, :owner_read, :user_id, :course_id, :created_at, :updated_at
json.url course_request_url(course_request, format: :json)