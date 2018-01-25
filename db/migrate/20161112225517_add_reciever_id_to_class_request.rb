class AddRecieverIdToClassRequest < ActiveRecord::Migration
  def change
    add_column :class_requests, :reciever_id, :integer
  end
end
