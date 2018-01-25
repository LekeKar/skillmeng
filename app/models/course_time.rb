class CourseTime < ActiveRecord::Base
  belongs_to :location
  belongs_to :course_day
  
  validates_length_of :description, :maximum => 100
  validates :start_time, :presence => {:message => 'Start time must be present'}
  validates :end_time, :presence => {:message => 'End time must be present'}
  validate :start_date_before_end_date

  def start_date_before_end_date
    if self.start_time > self.end_time
      errors.add(:start_time, "Start time should be before end time")
    end
  end
end
