class Contact < ActiveRecord::Base
  before_validation :smart_add_url_protocol
  
  belongs_to :course
  has_one :social_link, dependent: :destroy
  accepts_nested_attributes_for :social_link, reject_if: :all_blank, allow_destroy: true  
  
  
  validates :contact_name, :presence => {:message => 'Contact must have name'}
  validates :tel1, 	:numericality => true, :allow_blank => true,
  							:length => { is: 11}
  validates :tel2, 	:numericality => true,:allow_blank => true,
  							:length => { is: 11}
  validates :tel3, 	:numericality => true,:allow_blank => true,
  							:length => { is: 11}
  			
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true, :message => "doesn't look like a  valid email"

  protected 
  
  def smart_add_url_protocol
    unless self.tutor_website[/\Ahttp:\/\//] || self.tutor_website[/\Ahttps:\/\//]
      self.tutor_website = "http://#{self.tutor_website}"
    end
  end
end 

