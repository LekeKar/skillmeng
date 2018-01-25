class RemoveBrodcastLeftFromOrganizer < ActiveRecord::Migration
  def change
    remove_column :organizers, :broadcast_left
  end
end
