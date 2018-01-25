class CreateGalleryPics < ActiveRecord::Migration
  def change
    create_table :gallery_pics do |t|
      t.text :caption
      
      t.references :classroom, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
