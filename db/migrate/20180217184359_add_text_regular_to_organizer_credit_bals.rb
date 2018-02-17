class AddTextRegularToOrganizerCreditBals < ActiveRecord::Migration
  def change
    add_column :organizer_credit_bals, :text_regular, :integer
    add_column :organizer_credit_bals, :text_bonus, :integer
  end
end
