class AddLocationToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :location_id, :integer
  end
end
