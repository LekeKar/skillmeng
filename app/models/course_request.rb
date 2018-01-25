class CourseRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  
  validates :sender_trade_courses, :uniqueness => {:scope => :course_id, :message => "You have already sent a request using this course"}
  validates :sender_phone, :presence => {:message => 'This request must have a phone number'},
  			:numericality => true,
  			:length => { :minimum => 10, :maximum => 15 }

  validates :sender_trade_courses, :presence => {:message => 'You must offer a course to trade.'}
  validates :sender_email, :presence => {:message => 'You must input an email address to trade.'}
  validates_length_of :additional_info, :maximum => 300
  validates_format_of :sender_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true, :message => "doesn't look like a  valid email"


# Scopes
  scope :unread, -> {where(owner_read: false)}
  scope :accepted, -> { where(status: "accepted")}
end
