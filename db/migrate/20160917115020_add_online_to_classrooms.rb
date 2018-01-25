class AddOnlineToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :online, :boolean
  end
end
