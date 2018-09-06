class DropTableCoursePlans < ActiveRecord::Migration
  def change
    drop_table :org_bank_infos, force: :cascade
  end
end
