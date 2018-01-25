class AddOrganizerIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :organizer_id, :integer
    add_index :courses, :organizer_id
  end
end
