class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :reason
      t.text :explanation
      t.string :status
      t.text :admin_action
      t.references :classroom, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
