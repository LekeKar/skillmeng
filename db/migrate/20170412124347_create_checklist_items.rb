class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.string :description
      t.belongs_to :about, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
