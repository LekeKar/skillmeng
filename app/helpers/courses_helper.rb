module CoursesHelper
	def activate_link_text(activatable)  
	  activatable.activate? ? '<i class="fa fa-check"></i> Active'.html_safe  : '<i class="fa fa-ban"></i> Disabled'.html_safe 
	end 
	
	# Course completeness
	def calc_percent(score,total)
		result = (score.to_f / total)*100
		return result
	end
	
	def percentage_color(score)
		if score.between?(80, 100)
			result = "success"
		elsif score.between?(50, 80)
			result = "warning"
		else
			result = "danger"
		end
		return result
	end
	
	def check_cross(status)
		if status == "success"
			return '<td class="success text-center col-md-2"><i class="fa fa-check" aria-hidden="true"></i></td>'.html_safe
		else
			return '<td class="danger text-center col-md-2"><i class="fa fa-minus" aria-hidden="true"></i></td>'.html_safe
		end
	end
end
