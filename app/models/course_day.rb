class CourseDay < ActiveRecord::Base
  belongs_to :course
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true
  
  
  validates :weekday, :allow_blank => true, uniqueness: {:scope => :course_id, message: "This weekday aready exists"}
  validates :calendar_day, :allow_blank => true, uniqueness: {:scope => :course_id, message: "This calendar day aready exists"}
  validate :date_cannot_be_in_the_past
  
  
  # Scopes
	scope :past, -> { where('calendar_day < ?', Time.now)}
	scope :upcoming, -> { where('calendar_day > ?', Time.now)}
  
  def date_cannot_be_in_the_past
    if calendar_day.present? && calendar_day < Date.today
      errors.add(:calendar_day, "calender day can't be in the past")
    end
  end   
end
