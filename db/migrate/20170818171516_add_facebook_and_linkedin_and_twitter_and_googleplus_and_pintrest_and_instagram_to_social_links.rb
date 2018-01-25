class AddFacebookAndLinkedinAndTwitterAndGoogleplusAndPintrestAndInstagramToSocialLinks < ActiveRecord::Migration
  def change
    add_column :social_links, :facebook, :string
    add_column :social_links, :linkedin, :string
    add_column :social_links, :twitter, :string
    add_column :social_links, :googleplus, :string
    add_column :social_links, :pintrest, :string
    add_column :social_links, :instagram, :string
  end
end
