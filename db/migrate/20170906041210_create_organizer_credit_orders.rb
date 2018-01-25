class CreateOrganizerCreditOrders < ActiveRecord::Migration
  def change
    create_table :organizer_credit_orders do |t|
      t.integer :price
      t.references :organizer_order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
