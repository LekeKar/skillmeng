class HomepageSliderCourse < ActiveRecord::Base
  belongs_to :course
  
  has_attached_file :slider_image, styles: { original: "600x400>" }, default_url: "/images/:style/missing.jpeg"
  	validates_attachment_content_type :slider_image, content_type: /\Aimage\/.*\z/
  	validates_attachment_size :slider_image, :in => 0.megabytes..4.megabytes
  	validates :slider_image, :presence => {:message => 'You forgot to add the image.'}
end
