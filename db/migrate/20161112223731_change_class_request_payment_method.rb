class ChangeClassRequestPaymentMethod < ActiveRecord::Migration
  def change
  	rename_column :class_requests, :payment_method, :reciever_id
  end
end


