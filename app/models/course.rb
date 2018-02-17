class Course < ActiveRecord::Base
	before_save :downcase_fields
	before_destroy :check_for_extras
	after_validation :geocode

	belongs_to :user
	belongs_to :organizer
	has_one  :homepage_slider_course, dependent: :destroy
	has_one  :about, dependent: :destroy
	has_one  :course_payment, dependent: :destroy
	has_many :course_prices, through: :course_payment
	has_one  :contact, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :course_requests, dependent: :destroy
	has_many :gallery_pics, dependent: :destroy
	has_many :course_times, dependent: :destroy
	has_many :reports, dependent: :destroy
	has_many :course_days, dependent: :destroy
	has_many :locations, through: :course_days
	
	# Course promotions
	has_many :course_promotions, dependent: :destroy
	
	# Course tutors
	has_many :course_tutors, dependent: :destroy  # just the 'relationships'
  	has_many :tutors, through: :course_tutors, source: :tutor

	# Favorite courses of user
	has_many :favorite_courses, dependent: :destroy  # just the 'relationships'
  	has_many :favorited_by, through: :favorite_courses, source: :user do
    def textable
      where("favorite_courses.text = ?", true)
    end
    def emailable
      where("favorite_courses.email = ?", true)
    end
  end

	acts_as_taggable # Alias for acts_as_taggable_on :tags
	is_impressionable # Enables impression/views counting
	geocoded_by :full_address

	# Scopes
	scope :saed, -> { where(saed: true)}
	scope :andys_pick, -> { where(andys_pick: true)}
	scope :featured, -> { where(featured: true)}
	scope :child_friendly, -> { where(child_friendly: true)}
	scope :active, -> { where(course_state: "activated")}
	
	searchkick  suggest: [:title], word_start: [:title, :tutor, :tag_list]
	
	# add search ability
	def search_data
	  {
      title: title,
      category: category,
      tag_list: tag_list,
      tutor: tutor,
      locality: locality,
      local_area: local_area,
      course_state: course_state
    }
	end
	
	#FriendlyID config
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
	def should_generate_new_friendly_id?
	  slug.blank? || title_changed?
	end

  
  def slug_candidates
    [
      :title,
      [:title, :tutor],
      [:title, :tutor, :locality],
      [:title, :tutor, :locality, :local_area]
    ]
  end


	#ImagesPaparclip
	has_attached_file :display_pic, styles: { 
		medium: "600x600#", large: "1200x630#"
		}, default_url: "/images/:style/missing.png"
	validates_attachment_size :display_pic, :in => 0.megabytes..8.megabytes
	
	#Serializarion
	serialize :skill_level, Array

	#validations
	validates_attachment_content_type :display_pic, content_type: /\Aimage\/.*\Z/
	validate :tag_list_count
	validates :locality, :presence => {:message => 'A course must have a state'}
	validates :category, :presence => {:message => 'A course must have a category'}
	validates :local_area, :presence => {:message => 'A course must have a city or area'}
	validates :title, :slug, :presence => {:message => 'A course must have a name'}
	validates :slug, :presence => {:message => 'Yikes! Course slug not saved '}
	validates :schedule_style, :presence => {:message => 'Please choose a schedule style'}
	validates_length_of :title, :maximum => 25
	validates :title, :uniqueness => {:scope => :organizer_id, :message => "Course aready exists"}
	validates :tutor, :presence => {:message => 'A course must have an Organizer'}
	validates_length_of :tutor, :maximum => 25
	validate :check_exclusive_titles

  
   
 private
 
	def check_exclusive_titles
		unless self.tutor == "Ministry of the mindddddd"
	    if self.title.include?("101") || self.title.include?("102")  || self.title.include?("103")  || self.title.include?("104")
	      errors.add(:title, "101, 102, 103 and 104 are reserved names, sorry")
	    end
    end
  end

	def tag_list_count
	    errors[:tag_list] << "1 tag minimum" if tag_list.count < 1
	    errors[:tag_list] << "4 tags maximum" if tag_list.count > 4
 	end

  def downcase_fields
    self.tag_list.each do |tag|
    		tag.downcase!
		end
  end
  
  def check_for_extras
  	requests = CourseRequest.where(:course_id => self.id)
  	announcements = Announcement.course.where(:sender => self.id)
  	announcements = Announcement.course.where(:sender => self.id)
  	requests.destroy_all
  	announcements.destroy_all
  end
 
  def full_address
    "#{local_area}, #{locality}, #{'Nigeria'}"
  end
end
