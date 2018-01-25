class AddSeekCourse1ToClassPayments < ActiveRecord::Migration
  def change
    add_column :class_payments, :seek_course1, :string
    add_column :class_payments, :seek_course2, :string
    add_column :class_payments, :seek_course3, :string
  end
end
