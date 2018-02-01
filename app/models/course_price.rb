class CoursePrice < ActiveRecord::Base
  belongs_to :course_payment
  
  validates_length_of :explaination, :maximum => 110
end
