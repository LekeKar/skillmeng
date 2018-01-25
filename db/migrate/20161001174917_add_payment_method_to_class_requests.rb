class AddPaymentMethodToClassRequests < ActiveRecord::Migration
  def change
    add_column :class_requests, :payment_method, :string
  end
end
