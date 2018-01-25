class ChangeOrginiserPhoneToStrng < ActiveRecord::Migration
  def change
    change_column :organizers, :phone, :string
  end
end
