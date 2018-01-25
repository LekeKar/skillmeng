class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user_id, :uniqueness => {:scope => :course, :message => "may leave only one review"}
end
