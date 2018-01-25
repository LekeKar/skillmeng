class CreateClassPayments < ActiveRecord::Migration
  def change
    create_table :class_payments do |t|
      t.text :cash_instruction
      t.string :bank_name
      t.string :bank_account_number
      t.string :bank_account_name
      t.text :bank_instruction
      t.boolean :trade_by_barter
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
