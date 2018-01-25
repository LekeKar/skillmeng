class AddLocalAreaToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :local_area, :string
  end
end
