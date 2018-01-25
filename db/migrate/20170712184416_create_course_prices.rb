class CreateCoursePrices < ActiveRecord::Migration
  def change
    create_table :course_prices do |t|
      t.decimal :price
      t.string :for
      t.string :explaination
      t.references :course_payment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
