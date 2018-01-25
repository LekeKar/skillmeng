json.extract! contact, :id, :contact_name, :tel1, :tel2, :tel3, :email, :course_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)