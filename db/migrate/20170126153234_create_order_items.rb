class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :description
      t.integer :quantity
      t.belongs_to :transaction, index: true, foreign_key: true
      t.references :course_price, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
