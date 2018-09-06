class CoursePlan < ActiveRecord::Base
  belongs_to :course
  
  validates_numericality_of :price
end
