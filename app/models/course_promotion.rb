class CoursePromotion < ActiveRecord::Base
  belongs_to :course
  belongs_to :organizer_order

end
