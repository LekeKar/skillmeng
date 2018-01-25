class RemoveRecieverIdFromClassRequests < ActiveRecord::Migration
  def change
    remove_column :class_requests, :reciever_id, :string
  end
end
