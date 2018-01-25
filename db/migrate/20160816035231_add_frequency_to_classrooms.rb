class AddFrequencyToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :frequency, :string
  end
end
