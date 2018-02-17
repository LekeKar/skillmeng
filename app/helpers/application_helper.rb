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
  
  def course_state_explaination(course)
    if course.sold_out
      explaination = "This course is active but sold_out. It can be seen by all users"
    else 
      case course.course_state
        when "activated"
          explaination = "This course is published and can be seen by all users"
        when "setup"
          explaination = "This course has not been published and can only be seen by you."
        when "disabled"
          explaination = "This course has been disabled by you. It can only be seen by you"
        when "suspended"
          explaination = "This course has been disabled by admin. It can only be seen by you. Please contact us at info@skillmeng.com for inquiries"
      end 
    end 
  end

end
