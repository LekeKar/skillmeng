class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :content
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
