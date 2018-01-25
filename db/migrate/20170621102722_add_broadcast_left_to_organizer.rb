class AddBroadcastLeftToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :broadcast_left, :integer
  end
end
