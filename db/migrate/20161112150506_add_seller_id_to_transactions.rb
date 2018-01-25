class AddSellerIdToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :buyer_id, :integer
  	add_column :transactions, :seller_id, :integer
  end
end
