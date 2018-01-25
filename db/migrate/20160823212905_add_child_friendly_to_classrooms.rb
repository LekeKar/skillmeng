class AddChildFriendlyToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :child_friendly, :boolean
  end
end
