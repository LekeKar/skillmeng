class CreateClassRequests < ActiveRecord::Migration
  def change
    create_table :class_requests do |t|
      t.string :sender_name
      t.string :sender_email
      t.string :sender_phone
      t.text :additional_info
      t.boolean :owner_read
      t.references :user, index: true, foreign_key: true
      t.references :classroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
