class RemoveImportantFromAnnouncemnts < ActiveRecord::Migration
  def change
    remove_column :announcements, :important
  end
end
