class AddAboutToOrganizers < ActiveRecord::Migration
  def change
    add_column :organizers, :about, :text
  end
end
