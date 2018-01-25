class Report < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  validates :reason, :presence => {:message => 'Location must have street address'}
end
