class Location < ActiveRecord::Base
	before_validation :strip_blanks
	
	has_many :course_times, dependent: :destroy
	accepts_nested_attributes_for :course_times, reject_if: :all_blank, allow_destroy: true
	
	belongs_to :course_day
	belongs_to :organizer
	
	before_save :capitalize_fields
	before_save :set_country


	geocoded_by :full_street_address  
	after_validation :geocode, if: ->(obj){ obj.address_line2.present? and obj.address_line2_changed? }
	before_validation :geocode, :on => :update
	
	validates :address_line2, :presence => {:message => 'Location must have street address'}
	validates :city, :presence => {:message => 'Location must have city'}
	validates :state, :presence => {:message => 'Location must have state'}
	validate :require_course_times, :if => 'course_day.present?'

	private
    def set_country
     	self.country ||= "Nigeria"
    end
    
    def require_course_times
    	errors[:base] << "You must provide at least one course time" if self.course_times.size < 1
    end

    def full_street_address
		" #{address_line2}, #{city}, #{state}, 'Nigeria'"
    end

	def capitalize_fields
     	self.city.capitalize!
   	end

   	def strip_blanks
		self.city = self.city.strip
		self.state = self.state.strip
		self.address_line1 = self.address_line1.strip
		self.address_line2 = self.address_line2.strip
	end
end
