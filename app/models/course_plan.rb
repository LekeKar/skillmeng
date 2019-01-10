class CoursePlan < ActiveRecord::Base
  before_create :set_default_dates
  belongs_to :course
  
  #FriendlyID config
  extend FriendlyId
  friendly_id :plan_name, use: :slugged
	def should_generate_new_friendly_id?
	  slug.blank? || plan_name_changed?
	end
  #ImagesPaparclip
	has_attached_file :display_pic, styles: { 
		medium: "600x200#", large: "1200x630>"
		}, default_url: "/images/:style/plan.png"
		

	#Validations	
	validates_attachment_size :display_pic, :in => 0.megabytes..8.megabytes
  validates_attachment_content_type :display_pic, content_type: /\Aimage\/.*\Z/
  validates_numericality_of :price
  validate :date_cannot_be_in_the_past
  validate :end_date_cannot_be_before_start
    
  def date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "Start date can't be in the past")
    end
  end 
  
   def set_default_dates
    self.start_date = Time.now
    self.end_date = Time.now + 1.year 
  end 

  def end_date_cannot_be_before_start
    if start_date.present? && end_date < start_date
      errors.add(:end_date, "End date must be after start date")
    end
  end 
end
