class ChangeTransTypeFormat < ActiveRecord::Migration
  def change
  	change_column :transactions, :trans_type, :string
  end
end
