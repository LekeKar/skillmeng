class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :announcement
  
  scope :unread, -> { where(read: true)}
end
