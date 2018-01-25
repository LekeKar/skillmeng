module ApplicationHelper

	def title(title) 
		content_for(:title) { "#{title} | " }
	end 
	
	def meta_og_tags(properties = {})
    return unless properties.is_a? Hash

    og_tags = []

    properties.each do |property, value|
      og_tags << tag(:meta, property: "og:#{property}", content: value)
    end
 
    og_tags.join.html_safe  # Remember in Ruby the last line is returned
  end

end
