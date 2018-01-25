class CreateOrganizerOrders < ActiveRecord::Migration
  def change
    create_table :organizer_orders do |t|
      t.integer :total
      t.string :status
      t.references :organizer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
