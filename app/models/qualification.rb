class Qualification < ActiveRecord::Base
  belongs_to :course_tutor
  
  validates_length_of :description, :maximum => 150
end
