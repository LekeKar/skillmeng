class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :new_alert_info
  before_filter :get_user_organizer

  require 'paystack/objects/subaccounts.rb'
  require 'paystack.rb'
  
		protected

  		def configure_permitted_parameters
  			devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :tel, :role, :avatar])
    		devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname, :tel, :role, :avatar])
  		end
  		
  		def new_alert_info
  		  @new_barter = CourseRequest.unread.where( :reciever_id => current_user)
  		  @new_announcement = Alert.unread.where( :user_id => current_user)
  		end
  		
  		def get_user_organizer
  		  if current_user
  		    @user_organizer = current_user.organizer
  		    if !@user_organizer.nil?
    		    @course_slot_left = 3 - @user_organizer.courses.count
    		  end
  		  end 
  		end 
  		
end
