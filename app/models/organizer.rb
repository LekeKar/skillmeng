class Organizer < ActiveRecord::Base
  before_destroy :check_for_extras

  
  has_many :courses, dependent: :destroy
  has_many :tutors, dependent: :destroy
  has_many :organizer_orders, dependent: :destroy
  has_one :organizer_credit_bal, dependent: :destroy
  has_one :location, dependent: :destroy
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  has_one :org_bank_info, dependent: :destroy
  accepts_nested_attributes_for :org_bank_info, reject_if: :all_blank, allow_destroy: true
  
  belongs_to :user
  
  # Credit orders
  	has_many :credit_orders, through: :organizer_orders, source: :organizer_credit_order
  # payment info
  	has_many :course_payments, through: :courses
  # course days 
  	has_many :course_days, through: :courses
  # course locations
  	has_many :course_locations, through: :course_days, source: :locations
  	
  
  
  extend FriendlyId
  friendly_id :name, use: :slugged
	def should_generate_new_friendly_id?
	  slug.blank? || name_changed?
	end
  
  has_attached_file :logo, styles: { medium: "300x300#"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
	validates_attachment_size :logo, :in => 0.megabytes..4.megabytes
  
  
  validates_length_of :about, :maximum => 350
  validates_length_of :name, :maximum => 25
  validates :name, :uniqueness => {:message => "Organizer name aready exists"}
  validates :name, :presence => {:message => 'name must be present'}
  validates :phone, :numericality => true, :length => { is: 11}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "doesn't look like a valid email"
  validates :org_bank_info, presence: true
  validates :location, presence: true

private
 
 
 def check_for_extras
	announcements = Announcement.organizer.where(:sender => self.id)
	announcements.destroy_all
 end
 
    
end
