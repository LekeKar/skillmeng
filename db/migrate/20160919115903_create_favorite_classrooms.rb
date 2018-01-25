class CreateFavoriteClassrooms < ActiveRecord::Migration
  def change
    create_table :favorite_classrooms do |t|
      t.integer :classroom_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
