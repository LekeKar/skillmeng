class OrganizerOrder < ActiveRecord::Base
  
  has_one :organizer_credit_order, dependent: :destroy
  accepts_nested_attributes_for :organizer_credit_order, reject_if: :all_blank, allow_destroy: true
  
  has_many :course_promotions, dependent: :destroy
  accepts_nested_attributes_for :course_promotions, reject_if: :all_blank, allow_destroy: true
  
  belongs_to :organizer
  
end
