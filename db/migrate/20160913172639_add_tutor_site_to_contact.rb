class AddTutorSiteToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :tutor_website, :string
  end
end
