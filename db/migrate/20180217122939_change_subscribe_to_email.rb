class ChangeSubscribeToEmail < ActiveRecord::Migration
  def change
    rename_column :favorite_courses, :broadcast, :text
    rename_column :favorite_courses, :subscribe, :email
  end
end
