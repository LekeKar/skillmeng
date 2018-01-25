class RenameCertificateToReward < ActiveRecord::Migration
  def change
    rename_table :certificates, :course_rewards
  end
end
