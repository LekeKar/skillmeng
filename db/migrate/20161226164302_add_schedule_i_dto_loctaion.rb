class AddScheduleIDtoLoctaion < ActiveRecord::Migration
  def change
    add_column :locations, :schedule_id, :integer
    add_index :locations, :schedule_id
  end
end
