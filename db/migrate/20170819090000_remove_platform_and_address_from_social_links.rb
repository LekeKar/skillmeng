class RemovePlatformAndAddressFromSocialLinks < ActiveRecord::Migration
  def change
     remove_column  :social_links, :platform
     remove_column  :social_links, :address
  end
end
