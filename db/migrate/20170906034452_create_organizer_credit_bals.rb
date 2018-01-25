class CreateOrganizerCreditBals < ActiveRecord::Migration
  def change
    create_table :organizer_credit_bals do |t|
      t.integer :regular
      t.integer :bonus
      t.references :organizer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
