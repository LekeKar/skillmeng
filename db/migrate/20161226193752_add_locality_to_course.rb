class AddLocalityToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :locality, :string
  end
end
