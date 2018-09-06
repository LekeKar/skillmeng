class CreateOrgBankInfo < ActiveRecord::Migration
  def change
    create_table :org_bank_infos do |t|
      t.string :bank_name
      t.string :bank_account_number
      t.string :bank_account_name
      t.string :paystack_id
      t.string :paystack_plan
      t.integer :organizer_id
    end
  end
end
