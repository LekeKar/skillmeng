class CourseTutor < ActiveRecord::Base
  belongs_to :course
  belongs_to :tutor
end
