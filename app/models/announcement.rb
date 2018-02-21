class Announcement < ActiveRecord::Base
  before_validation :strip_blanks
  before_validation :smart_add_url_protocol
  
  has_many :alerts, dependent: :destroy # just the 'relationships'
  has_many :users, through: :alerts
  
  has_attached_file :photo, styles: { rectangle: "810x450#"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  validates_attachment_size :photo, :in => 0.megabytes..4.megabytes
  
  validates_length_of :subject, :maximum => 40
  validates :subject, :presence => {:message => 'Announcement must have a subject'}
  validates_length_of :body, :maximum => 400
  validates :body, :presence => {:message => 'Announcement must have a body'}
  
  scope :admin, -> { where(sender_type: "admin")}
  scope :organizer, -> { where(sender_type: "organizer")}
  scope :course, -> { where(sender_type: "course")}
  
  protected 
  
  def smart_add_url_protocol
    unless self.action_link[/\Ahttp:\/\//] || self.action_link[/\Ahttps:\/\//]
      self.action_link = "http://#{self.action_link}"
    end
  end
  
  def strip_blanks
  	self.subject = self.subject.strip
  end
  
end