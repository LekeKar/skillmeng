class OrganizerOrder < ActiveRecord::Base
  before_save :get_promotions
  
  has_one :organizer_credit_order, dependent: :destroy
  accepts_nested_attributes_for :organizer_credit_order, reject_if: :all_blank, allow_destroy: true
  
  has_many :course_promotions, dependent: :destroy, inverse_of: :organizer_order
  accepts_nested_attributes_for :course_promotions, reject_if: :all_blank, allow_destroy: true
  
  belongs_to :organizer
  
  scope :successful, -> { where(status: "success")}
  
  def get_promotions
    self.course_promotions = self.course_promotions.uniq(&:course_id)
  end
end
