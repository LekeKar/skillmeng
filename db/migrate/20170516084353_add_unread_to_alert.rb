class AddUnreadToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :read, :boolean, :default => true
  end
end
