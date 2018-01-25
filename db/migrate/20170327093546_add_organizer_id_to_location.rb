class AddOrganizerIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :organizer_id, :integer
    add_index :locations, :organizer_id
  end
end
