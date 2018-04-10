namespace :ade do
  desc "Resets organizers bonus credit to 50"
  task :bonus_credit_top_up => :environment do 
    if Time.now.day == 15
      #find organizers
        
        @orgs = Organizer.all
      
      #update bonus credit balance
        for org in @orgs
          
          amount = {email:50}
          org.organizer_credit_bal.email_bonus = amount[:email]
          org.organizer_credit_bal.save 
          
          # send email
          AnnouncementMailer.credit_refill(org, amount).deliver_now
          
          # send in-app announcement  
        	@ann = Announcement.create(subject: "Bonus credit refilled!",
  																			body: "Hi #{org.user.fname}, your bonus credit has been topped-up!. Your bonus email is now  #{amount[:email]}. Bonus credit doesn't roll-over so make sure you spend it.",
  																			sender: "Andy",
  																			sender_type:"admin",
  																			email: false,
  																			text: false,
  																			action_type: "view Manager",
  																			action_link: "",
  																			action_id: "")
      		@ann.users << org.user
          
          
        end 
        
        puts "Credits updated unt emails sent Oga!"
    else
      puts "Oga it ain't the 15th"
    end
  end
end 