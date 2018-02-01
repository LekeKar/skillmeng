class CoursePayment < ActiveRecord::Base
  has_many :course_prices, dependent: :destroy
	accepts_nested_attributes_for :course_prices, reject_if: :all_blank, allow_destroy: true

  validates_length_of :refund_instruction, :maximum => 300
  validates :bank_name, :presence => {:message => 'Payment info requires bank name'}
  validates :bank_account_name, :presence => {:message => 'Payment info requires account name'}
  validates :bank_account_number, :presence => {:message => 'Payment info requires account number'}
  validates :bank_account_number, format: { with: /\A\d+\z/, message: "Integer only. No signs allowed." }
  validate  :require_price_plans

  private
    def require_price_plans
    	errors[:base] << "You must provide at least one price plan" if self.course_prices.size < 1
    end
end
