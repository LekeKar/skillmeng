class FavoriteCourse< ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  
  
  # Scopes
	scope :subscribed, -> { where(broadcast: true)}
end
