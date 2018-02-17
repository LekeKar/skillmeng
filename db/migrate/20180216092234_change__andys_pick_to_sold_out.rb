class ChangeAndysPickToSoldOut < ActiveRecord::Migration
  def change
    rename_column :courses, :andys_pick, :sold_out
  end
end
