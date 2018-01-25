class CreateCoursePromotions < ActiveRecord::Migration
  def change
    create_table :course_promotions do |t|
      t.integer :price
      t.references :course, index: true, foreign_key: true
      t.references :organizer_order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
