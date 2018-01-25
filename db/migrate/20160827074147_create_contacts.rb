class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :contact_name
      t.string :tel1
      t.string :tel2
      t.string :tel3
      t.string :email
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
