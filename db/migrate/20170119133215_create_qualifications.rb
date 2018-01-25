class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :description
      t.belongs_to :course_teacher, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
