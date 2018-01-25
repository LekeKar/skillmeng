class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.string :platform
      t.string :address
      t.belongs_to :course_tutor, index: true, foreign_key: true
      t.belongs_to :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
