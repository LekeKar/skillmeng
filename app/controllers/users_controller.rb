class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :find_user_courses, only: [:my_courses, :show]
	after_action :read_all_barter, only: [:barter]
	after_action :read_all_news, only: [:show, :news] 
	after_action :read_all_messages, only: [:show]

	def show
		@meta_description = "View summary of activities that pertain to you and see what you have missed. Also view and edit your user profile from here."
	  @conversations = current_user.mailbox.inbox.order('updated_at DESC')
	  @announcements = current_user.announcements.order('created_at DESC')
	end 
	
	def news
		@meta_description = "Never miss a thing! Get the all announcments for you on this page."
		@announcements = current_user.announcements.order('created_at DESC').page(params[:page]).per_page(9)
		respond_to do |format|
      format.html
      format.js
    end
	end
	
	def barter
		@meta_description = "Learn a skill by offerning to teach another. Check status and respond to your barter request & offers here. "
  	@barter_rec = CourseRequest.where(:reciever_id => current_user.id).order( 'created_at DESC' ).paginate(:page => params[:page], :per_page => 12)
		@barter_sen = CourseRequest.where(:user_id => current_user.id).order( 'created_at DESC' ).paginate(:page => params[:page], :per_page => 12)

	end
	
	def saved_courses
		@meta_description = "View latest news and change announcement settings for followed courses."
		@favorite_courses = FavoriteCourse.where(:user_id => current_user.id).order( 'created_at DESC' ).paginate(:page => params[:page], :per_page => 12)
	end 
	
	def barter_response
		barter_req = CourseRequest.find(params[:course_request_id])
		@offer_course = Course.friendly.find(barter_req.sender_trade_courses)
  	@ask_course = Course.friendly.find(barter_req.course_id)
    @ask_organizer = Organizer.friendly.find( @ask_course.organizer_id )
    @offer_organizer = Organizer.friendly.find( @offer_course.organizer_id )
  
		case params[:type]
		when "accept"
			@ans = "accepted"
			barter_req.status = @ans
		when "decline"
			@ans = "declined"
			barter_req.status = @ans
		end 
		
		
		@ann = Announcement.create(subject: "Barter offer was #{@ans}",
																				body: "Hi #{@offer_course.user.fname},\nYour offer for #{@ask_course.title} was #{@ans}.",
																				sender: @ask_course.organizer.id,
																				sender_type:"organizer",
																				broadcast: false,
																				action_type: "barter_response",
																				action_link: "",
																				action_id: "")
		@ann.users << @offer_course.user
		AnnouncementMailer.barter_response(@offer_course.user, barter_req, @ans).deliver_now
		barter_req.save
		redirect_to :back, notice: 'Notification sent!'
	end	
	
	
	private 
	
	def find_user_courses
		@user_courses = current_user.courses.order( 'title ASC' )
	end 
	
	def find_user_announcements
		
	end
	
	def read_all_barter
		if params[:type] == "received" 
			CourseRequest.where(:reciever_id => current_user.id).update_all(:owner_read => true)
		end
	end 
	
	def read_all_news
		Alert.where(:user_id => current_user.id).update_all(:read => false)
	end 
	
	def read_all_messages
		@conversations.each do |conversation|
			conversation.mark_as_read(current_user)
		end
	end 
     
end


