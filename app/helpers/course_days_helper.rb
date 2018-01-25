module CourseDaysHelper
  
  def time_format(datetime)
	  datetime.strftime('%I:%M %p') unless datetime.blank?
	end
	
	def date_format(datetime)
	  datetime.strftime('%A %m %b %Y') unless datetime.blank?
	end
end
