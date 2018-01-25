class AddCourseCountToSearchTerms < ActiveRecord::Migration
  def change
    add_column :search_terms, :course_count, :integer, default: 0
  end
end
