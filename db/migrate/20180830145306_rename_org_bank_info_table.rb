class RenameOrgBankInfoTable < ActiveRecord::Migration
  def change
    rename_table :org_bank_info, :org_bank_infos
  end
end
