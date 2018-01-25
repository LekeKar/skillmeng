class ChangeChildFriendlytoActivate < ActiveRecord::Migration
  def change
  	rename_column :classrooms, :child_friendly, :activate
  end
end
