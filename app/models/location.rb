class Location < ActiveRecord::Base
	before_validation :strip_blanks

	belongs_to :organizer
	
	before_save :capitalize_fields
	before_save :set_country


	geocoded_by :full_street_address  
	after_validation :geocode, if: ->(obj){ obj.address_line2.present? and obj.address_line2_changed? }
	before_validation :geocode, :on => :update
	
	validates :address_line2, :presence => {:message => 'Location must have street address'}
	validates :city, :presence => {:message => 'Location must have city'}
	validates :state, :presence => {:message => 'Location must have state'}

	private
    def set_country
     	self.country ||= "Nigeria"
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
