class ChangeBroadcastToEmail < ActiveRecord::Migration
  def change
    rename_column :announcements, :broadcast, :email
    add_column :announcements, :text, :boolean,  default: false
  end
end
