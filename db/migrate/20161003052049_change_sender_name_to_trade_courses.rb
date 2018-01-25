class ChangeSenderNameToTradeCourses < ActiveRecord::Migration
  def change
  	rename_column :class_requests, :sender_name, :sender_trade_courses
  end
end
