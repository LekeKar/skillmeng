class AddSubscritionVericationToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :subscription_code, :string
  	add_column :transactions, :email_token, :string
  	add_column :transactions, :subscription_status, :string
  end
end
