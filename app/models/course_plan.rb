class CoursePlan < ActiveRecord::Base
  belongs_to :course
  
  #ImagesPaparclip
	has_attached_file :display_pic, styles: { 
		medium: "600x200#", large: "1200x630>"
		}, default_url: "/images/:style/missing.png"
	
	#Validations	
	validates_attachment_size :display_pic, :in => 0.megabytes..8.megabytes
    validates_attachment_content_type :display_pic, content_type: /\Aimage\/.*\Z/
    validates_numericality_of :price
end
