class GalleryPic < ActiveRecord::Base
	belongs_to :course

	has_attached_file :image, styles: { medium: "300x200#", original: "1200x630>" }, default_url: "/images/:style/missing.png"
  	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  	validates :image, :presence => {:message => 'You forgot to add the image.'}
  	validates_attachment_size :image, :in => 0.megabytes..4.megabytes
  	validates_length_of :caption, :maximum => 300

end
