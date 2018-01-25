class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :subject
      t.text :body
      t.integer :sender
      t.string :sender_type
      t.boolean :important

      t.timestamps null: false
    end
  end
end
