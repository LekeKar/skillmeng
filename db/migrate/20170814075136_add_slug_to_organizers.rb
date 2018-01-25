class AddSlugToOrganizers < ActiveRecord::Migration
  def change
    add_column :organizers, :slug, :string
    add_index :organizers, :slug, unique: true
  end
end
