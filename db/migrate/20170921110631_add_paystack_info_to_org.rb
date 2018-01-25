class AddPaystackInfoToOrg < ActiveRecord::Migration
  def change
    add_column :organizer_orders, :transaction_reference, :string
    add_column :organizer_orders, :access_code, :string
    add_column :organizer_orders, :authorization_url, :string
    add_column :organizer_orders, :transaction_id, :integer
    add_column :organizers, :paystack_id, :integer
  end
end
