class AddBroadcastAndActionTypeAndActionIdToAnnouncement < ActiveRecord::Migration
  def change
    add_column :announcements, :broadcast, :boolean, :default => false 
    add_column :announcements, :action_type, :string
    add_column :announcements, :action_link, :string
    add_column :announcements, :action_id, :integer
  end
end
