class SocialLink < ActiveRecord::Base
  belongs_to :course_tutor
  belongs_to :contact
end
