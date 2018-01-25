namespace :ade do
  desc "Resets organizers bonus credit to 50"
  task :bonus_credit_top_up => :environment do 
    #find organizers
      @orgs = Organizer.all
    
    #update bonus credit balance
      for org in @orgs
        org.organizer_credit_bal.email_bonus = 50
        org.organizer_credit_bal.save 
        
        # send email
        AnnouncementMailer.credit_refill(org).deliver_now
        
        # send in-app announcement  
      	@ann = Announcement.create(subject: "Bonus credit refilled!",
																			body: "Hi #{org.user.fname}, your bonus credit has been re-filled and is back to 50! Bonus credit doesn't roll-over so make sure you spend it.",
																			sender: "Andy",
																			sender_type:"admin",
																			broadcast: false,
																			action_type: "view Manager",
																			action_link: "",
																			action_id: "")
    		@ann.users << @org.user
        
        
      end 
      
      puts "Credits updated unt emails sent Oga!"
  end
end 