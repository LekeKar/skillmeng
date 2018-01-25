class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :name
      t.string :issuing_body
      t.text :description
      t.references :about, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
