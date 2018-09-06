class OrgBankInfo < ActiveRecord::Base
  belongs_to :organizer
  
  validates :bank_name, :presence => {:message => 'Bank info requires bank name'}
  validates :bank_account_name, :presence => {:message => 'Bank info requires account name'}
  validates :bank_account_number, :presence => {:message => 'Bank info requires account number'}
  validates :bank_account_number, format: { with: /\A\d+\z/, message: "Integer only. No signs allowed." }
 
end
