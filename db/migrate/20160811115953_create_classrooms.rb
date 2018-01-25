class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :title
      t.float :price
      t.string :tutor
      t.boolean :saed
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
