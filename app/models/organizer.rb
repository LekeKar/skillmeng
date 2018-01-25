class Organizer < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_many :tutors, dependent: :destroy
  has_many :organizer_orders, dependent: :destroy
  has_one :organizer_credit_bal, dependent: :destroy
  has_one :location, dependent: :destroy
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  
  belongs_to :user
  
  # Credit orders
  	has_many :credit_orders, through: :organizer_orders, source: :organizer_credit_order
  
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_attached_file :logo, styles: { medium: "300x300#", large: "1200x630#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
	validates_attachment_size :logo, :in => 0.megabytes..4.megabytes
  
  
  validates_length_of :about, :maximum => 350
  validates_length_of :name, :maximum => 25
  validates :name, :uniqueness => {:message => "Organizer name aready exists"}
  validates :name, :presence => {:message => 'name must be present'}
  validates :phone,   :numericality => true, :length => { :minimum => 10, :maximum => 15 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "doesn't look like a valid email"
end
