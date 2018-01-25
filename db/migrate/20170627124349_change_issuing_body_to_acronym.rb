class ChangeIssuingBodyToAcronym < ActiveRecord::Migration
  def change
    rename_column :course_rewards, :issuing_body, :acronym
  end
end
