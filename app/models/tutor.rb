class Tutor < ActiveRecord::Base
    attr_accessor :tutored_courses
    before_validation :smart_add_url_protocol
    
    belongs_to :organizer
    has_many :qualifications, dependent: :destroy
    accepts_nested_attributes_for :qualifications, reject_if: :all_blank, allow_destroy: true
    has_one :social_link, dependent: :destroy
    accepts_nested_attributes_for :social_link, reject_if: :all_blank, allow_destroy: true  
    
    # Course tutors
  	has_many :course_tutors, dependent: :destroy  # just the 'relationships'
    has_many :taught_courses, through: :course_tutors, source: :course 
    
    has_attached_file :avatar, styles: { medium: "300x300#"}, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    validates_attachment_size :avatar, :in => 0.megabytes..4.megabytes
  	validates_length_of :bio, :maximum => 300
  	
  	
  	protected 
  
      def smart_add_url_protocol
        unless self.website[/\Ahttp:\/\//] || self.website[/\Ahttps:\/\//]
          self.website = "http://#{self.website}"
        end
      end
  
end
