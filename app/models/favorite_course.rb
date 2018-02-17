class FavoriteCourse< ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  
  
  # Scopes
	scope :email, -> { where(email: true)}
	scope :text, -> { where(text: true)}
end
