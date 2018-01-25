class RemoveScheduleIdFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :schedule_id, :integer
  end
end
