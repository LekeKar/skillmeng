class AddWebsiteToOrganizer < ActiveRecord::Migration
  def change
    add_column :organizers, :website, :string
  end
end
