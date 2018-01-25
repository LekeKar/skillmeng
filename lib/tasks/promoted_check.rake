namespace :ade do
  desc "Check promoted courses status and updates if expired"
  task :promoted_check => :environment do 
    #check promoted courses
      @promoted_list = Course.featured
    
    #update 
      for course in @promoted_list
        if course.course_promotions.last.created_at < 1.week.ago
          course.update_attribute(:featured, false)
          
          # send in-app announcement  
        	@ann = Announcement.create(subject: "#{course.title} promotion has ended",
  																			body: "Hi #{course.user.fname}, your promotion for #{course.title} has run its er ..course",
  																			sender: "Andy",
  																			sender_type:"admin",
  																			broadcast: false,
  																			action_type: "view Manager",
  																			action_link: "",
  																			action_id: "")
      		@ann.users << course.user
            
        end
      end 
      
      puts "Done Sir!"
  end
end 