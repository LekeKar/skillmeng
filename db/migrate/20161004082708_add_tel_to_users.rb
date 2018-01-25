class AddTelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tel, :string,              null: false, default: ""

  end
end
