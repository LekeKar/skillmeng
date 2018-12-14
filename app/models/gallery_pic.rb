class GalleryPic < ActiveRecord::Base
	belongs_to :course

	has_attached_file :image, styles: { medium: "1080x1080#", original: "1200x630>" }, default_url: "/images/:medium/missing.png"
  	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  	validates :image, :presence => {:message => 'You forgot to add the image.'}
  	validates_attachment_size :image, :in => 0.megabytes..4.megabytes

end
