class AddOwnerReadToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :owner_read, :boolean, :default => false
  end
end
