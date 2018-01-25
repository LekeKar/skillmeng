class ChangeTransactionPriceToTotal < ActiveRecord::Migration
  def change
    rename_column :transactions, :price, :total
    remove_column :transactions, :quantity
  end
end
