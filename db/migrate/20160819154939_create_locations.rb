class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :country
      t.float :latitude
      t.float :longitude
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
