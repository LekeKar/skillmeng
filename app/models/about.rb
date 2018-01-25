class About < ActiveRecord::Base
  belongs_to :course
  has_many :requirements, dependent: :destroy
  accepts_nested_attributes_for :requirements, reject_if: :all_blank, allow_destroy: true
  has_many :checklist_items, dependent: :destroy
  accepts_nested_attributes_for :checklist_items, reject_if: :all_blank, allow_destroy: true
  has_many :course_rewards, dependent: :destroy
  accepts_nested_attributes_for :course_rewards, reject_if: :all_blank, allow_destroy: true
  
  validates_length_of :content, :maximum => 300
  validates :content, :presence => {:message => 'Content must be present'}
end
