class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :authorisation_url
      t.string :access_code
      t.string :reference
      t.string :status
      t.integer :quantity
      t.integer :price
      t.integer :trans_type
      t.references :user, index: true, foreign_key: true
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
