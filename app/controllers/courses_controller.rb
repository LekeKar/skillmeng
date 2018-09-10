class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :make_primary, :switch_theme, :course_wizard, :course_manager, :requests, :toggle_activate, :toggle_sold_out, :favorite, :edit, :update, :destroy, :rating, :location_accuracy, :contact_info, :gallery, :schedule, :payment]
  before_action :set_info, except: [:autocomplete, :course_wizard, :destroy, :update, :edit, :index, :search, :new, :create, :toggle_text, :toggle_email_broadcast, :toggle_text_broadcast]
  before_action :authenticate_user!, except: [:autocomplete, :course_wizard, :index, :search, :show, :rating, :contact_info, :gallery, :payment] 
  before_action :user_auth, only: [:edit, :update, :course_wizard, :destroy, :course_manager, :location_accuracy, :requests]  
  before_action :activated_check, only: [:show]
  before_action :suspended_check, only: [:destroy]
  before_action :check_wizard, only: [:new]
  before_action :min_price, only: [:show, :gallery, :rating]  
  before_action :class_limits, only: [:new, :create]
  before_action :course_completeness, only: [:course_manager, :show]
  after_action  :course_completeness, only: [:show]
  before_action :user_manager_check, only: [:new, :create, :edit, :update ]
  before_action :set_user_fav, only: [:toggle_text, :toggle_email_broadcast, :toggle_text_broadcast]


  # GET /courses, 
  # GET /courses.json
  def index
    if current_user && current_user.organizer
      @organizer = current_user.organizer
    end
      @meta_description = "Browse courses on skillmeng, pick one and begin building your future one."
   
    
    if params[:tag] 
      @courses = Course.active.tagged_with(params[:tag]).order(featured: :desc, completeness: :desc).page(params[:page]).per_page(8)
    elsif params[:search_cat]
       @courses = Course.where(:category => params[:search_cat]).active.order(featured: :desc, completeness: :desc).page(params[:page]).per_page(8)
    else
      @courses = Course.active.order(featured: :desc, completeness: :desc).page(params[:page]).per_page(8)
    end 
    
    respond_to do |format|
      format.html
      format.js
    end
    
    
  end

  def search
    @meta_description = "Browse courses on skillmeng, pick one and begin building your future one."
   
    if params[:search].present?
      @courses = Course.search(params[:search], where:{course_state: "activated"}, boost_where: {featured: true}, suggest: true, misspellings: {below: 5}, page: params[:page], per_page: 10)
      search_phrase = params[:search].downcase
      SearchTerm.create!(term: search_phrase, course_count: @courses.count)
    else
      @courses = Course.order(featured: :desc, where:{course_state: "activated"}, completeness: :desc).page(params[:page]).per_page(9)
    end 
    
    respond_to do |format|
      format.html
      format.js
    end
    
  end

  
  def autocomplete
    render json: Course.active.search(params[:query], {
      fields: ["tag_list","title^5","tutor"],
      match: :word_start,
      where:{course_state: "activated"},
      boost_where: {featured: true},
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map(&:title) 
  end
  
  def course_wizard
    if session[:setup_wizard] && params[:type] == "end" 
      session.delete(:setup_wizard)
      redirect_to @course, notice: "You can continue to edit #{@course.title} here."
    elsif params[:type] == "start"
      session[:setup_wizard] = "basic_info"
      redirect_to edit_course_path(@course), notice: "#{@course.title} setup wizard initiated."
    end
  end 
  
  def make_primary
    for course in @organizer.courses.where.not(id: @course.id)
      course.update_attribute(:primary, false)
    end
    @course.update_attribute(:primary, true)
    redirect_to :back, notice: "#{@course.title} is now your primary course."
  end
  
  # GET /courses/1 
  # GET /courses/1.json
  def show
    take_impression
    
    # capture metadescription
    if @course.about
      @meta_description = @course.about.content
    else
      @meta_description = "#{@course.title}, a course on Skillmeng"
    end
    
    # capture metadescription
    @og_properties = {  
      title: "Course | #{@course.title}",
      type: 'website',
      image: @course.display_pic.url(:large),
      url: "#{ENV["SKILLMENG_SITE"]}/courses/#{@course.slug}",
      fb: ENV["FACEBOOK_ID"],
      description: @meta_description
    }
  
    combo = []
    for tag in @course.tag_list
      search = Course.search(tag, where:{course_state: "activated"})
      combo += search.results
    end
    combo.delete @course
    similar_courses = combo.uniq.shuffle.take(6).sort_by! {|e| e.featured? ? 0 : 1}
    
    unless similar_courses.empty?
      @other_courses = similar_courses
      @other_courses_type = "similar"
    else
      @other_courses_type = "promoted"
      promoted_courses = Course.active.order(featured: :desc, completeness: :desc).featured.shuffle.first(6)
      promoted_courses.delete @course
      @other_courses = promoted_courses
    end  
    
  end

  def rating
    take_impression
    @reviews_paginate = @course.reviews.order("created_at DESC").page(params[:page]).per_page(9)
  end 

  def payment
  end 
 
  
  def toggle_activate
    
    case @course.course_state
      when "activated" 
        @course.update_attribute(:course_state, "disabled")
        redirect_to :back, alert: "#{@course.title} has been disabled"
      when "disabled"
        @course.update_attribute(:course_state, "activated")
        redirect_to :back, notice: "#{@course.title} has been activated"
      when "suspended"
        redirect_to :back, notice: "#{@course.title} has been suspended by admin. Please contact us at info@skillmeng.com"
      when "setup"
        @course.update_attribute(:course_state, "activated")
        redirect_to :back, notice: "#{@course.title} has been published"
    end 
  

  end
  
  def toggle_text
    if @user_fav.text == true
      @user_fav.text = false
      @user_fav.save
      message = "#{@course.title} will no longer post to your newsfeed"
    else
      @user_fav.text = true
      @user_fav.save
      message = "#{@course.title} can post to yout newsfeed"
    end
    
    respond_to do |format|
      format.html { redirect_to :back, notice: message };
      format.json { head :no_content, notice: message }
      format.js   { head :no_content, notice: message }
      format.xml  { head :no_content, notice: message }
    end
  end
  
  def toggle_text_broadcast
     if @user_fav.text == true
      @user_fav.text = false
      @user_fav.save
      message = "#{@course.title} will no longer post to your text"
    else
      @user_fav.text = true
      @user_fav.save
      message = "#{@course.title} can post to your text"
    end
    
    respond_to do |format|
      format.html { redirect_to :back, notice: message };
      format.json { head :no_content }
      format.js   { head :no_content }
      format.xml  { head :no_content }
    end
  end
  
  
  def toggle_email_broadcast
    if @user_fav.email == true
      @user_fav.email = false
      @user_fav.save
      message = "#{@course.title} will no longer post to your email"
    else
      @user_fav.email = true
      @user_fav.save
      message = "#{@course.title} can post to your email"
    end
    
    respond_to do |format|
      format.html { redirect_to :back, notice: message };
      format.json { head :no_content }
      format.js   { head :no_content }
      format.xml  { head :no_content }
    end
  end

  def favorite
    if current_user.favorites.exists?(@course)
      current_user.favorites.delete(@course)
      message = "#{@course.title} removed from interests"
      message_type = "alert"
    elsif current_user == @course.user_id
      message =  "Oga, you own this class"
      message_type = "alert"
    else
      current_user.favorites << @course
      message = "#{@course.title} added to interests"
      message_type = "notice"
    end 
  
    respond_to do |format|
      format.html { redirect_to :back, notice: message };
      format.json { head :no_content }
      format.js   { head :no_content }
      format.xml  { head :no_content }
    end
  end

  def contact_info
    
  end 


  def schedule 
    
  end 

  def gallery
    take_impression
    @gallery_pics = @course.gallery_pics.page(params[:page]).per_page(6)
  end 

  def requests
    @course_requests = @course.course_requests.page(params[:page]).per_page(12)
  end
  
  def course_manager
    @announcement = Announcement.new
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
    @total_email_credit = @organizer.organizer_credit_bal.email_regular + @organizer.organizer_credit_bal.email_bonus
    @total_text_credit = @organizer.organizer_credit_bal.text_regular + @organizer.organizer_credit_bal.text_bonus
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
     
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = @user_organizer.courses.build(course_params)
    @course.course_state = "setup"
    @course.user_id = current_user.id
    
    # makes organizers first course primary
  	if @user_organizer.courses.count < 1
  	  @course.primary = true
  	end 
    @course.save

    respond_to do |format|
      if @course.save
        session[:setup_wizard] = "basic_info"
        format.html { redirect_to new_course_about_path(@course), notice: "#{@course.title} was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
  
    @about = @course.about
    @course.save
    
    respond_to do |format|
      if @course.update(course_params)
        if session[:setup_wizard]
          session[:setup_wizard] = "basic_info"
          if @about
  	 	      format.html { redirect_to edit_course_about_path(@course, @about), notice: "#{@course.title} was successfully updated."}
    	 	  else
    	 	    format.html { redirect_to new_course_about_path(@course), notice: "#{@course.title} was successfully updated."}
    	 	  end
    	  else
          format.html { redirect_to @course, notice: "#{@course.title} was successfully updated." }
        end
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    @organizer = current_user.organizer
    
    respond_to do |format|
      format.html { redirect_to @organizer, notice: "#{@course.title} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
  
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      if params[:id]
        @course = Course.friendly.find(params[:id])
      else
        @course = Course.friendly.find(params[:course_id]) 
      end
    end
    
    def set_user_fav
      @user_fav = FavoriteCourse.find(params[:favorite_course_id])
      @course = Course.friendly.find(@user_fav.course_id)
    end
  
    
    def course_completeness
      # Basic Details (total 30)
      @basic_score = 10
      @course.display_pic.exists? ? @basic_score += 10 : @basic_score += 0 
      @course.tags.count > 2 ? @basic_score += 10 : @basic_score += 0
      
      # Contact (total 30)
      @contact_score = 0
      @contact.present? ? @contact_score += 10 : @contact_score += 0 
      if @contact.present?
        @contact.email.present? ? @contact_score += 10 : @contact_score += 0 
        @contact.tel1.present? ? @contact_score += 10 : @contact_score += 0
      end
      
      # About/Requirements (total 10)
      @about_req_score = 0
      @about.present? ? @about_req_score += 10 : @about_req_score += 0
      
      # Plans (total 10)
      @plans_score = 0
      @course_plans.any? ? @plans_score += 10 : @plans_score += 0
      
      # Gallery (total 10)
      @gallery_score = 0
      case @gallery_pics.count
        when 0
          @gallery_score += 0
        when 1
          @gallery_score += 3
        when 2
          @gallery_score += 7
        else
          @gallery_score += 10
      end 
      
      # Tutor (total 10)
      @tutor_score = 0
      @tutors.any? ? @tutor_score += 10 : @tutor_score += 0
      
      # Total
      @total_score = @basic_score + @contact_score + @about_req_score + @plans_score + @gallery_score + @tutor_score
      @course.update_attribute(:completeness, @total_score) 
    end
    
    def set_info

      @organizer = @course.organizer
      @about = @course.about
      @contact = @course.contact
      @online = @course.online
      @reports = @course.reports
      @course_plans = @course.course_plans.order(plan_name: :asc)
      @course_request = @course.course_requests
      @announcements = Announcement.course.where(:sender => @course.id).order('created_at DESC')
      @total_email_credit = @organizer.organizer_credit_bal.email_regular + @organizer.organizer_credit_bal.email_bonus
      @total_text_credit = @organizer.organizer_credit_bal.text_regular + @organizer.organizer_credit_bal.text_bonus
      @textable_users = @course.favorited_by.textable.where.not(tel: '')
      @emailable_users = @course.favorited_by.emailable
      @gallery_pics = @course.gallery_pics.page(params[:page])
      @tutors = @course.tutors.includes(:course_tutors).order("course_tutors.created_at asc")
      
      if @user_organizer && @user_organizer.tutors
        available_tutor_prep = @user_organizer.tutors
        @available_tutors = available_tutor_prep - @tutors
      end 
      @reviews = @course.reviews
      @reviews_paginate = @course.reviews.order("created_at DESC").page(params[:page]).per_page(2)
      
      # if @course.schedule_style == "Recurring weekdays"
      #   @course_days = @course.course_days.order("CASE course_days.weekday WHEN 'Weekdays (Mon - Fri)' THEN 0 " \
      #                                                     "WHEN 'Monday' THEN 1 " \
      #                                                     "WHEN 'Tuesday' THEN 2 " \
      #                                                     "WHEN 'Wednesday' THEN 3 " \
      #                                                     "WHEN 'Thursday' THEN 4 " \
      #                                                     "WHEN 'Friday' THEN 5 " \
      #                                                     "WHEN 'Saturday' THEN 6 " \
      #                                                     "WHEN 'Sunday' THEN 7 " \
      #                                                     "WHEN 'Weekends (Sat & Sun)' THEN 8 END")
      # else
      #   @course_days = @course.course_days.order('course_days.calendar_day ASC')
      # end

      if @reviews.blank?
        @avg_review = 0
      else
        @avg_review = @reviews.average(:rating).present? ? @reviews.average(:rating).round(2) : 0
      end 
    end 
    
    def min_price
      @min_price = @course.course_plans.minimum(:price)
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :local_area, :tutor, :saed, :schedule_style, :organizer_id, :category, :user_id, :display_pic, :tag_list, :course_state, :locality, :attended_by, :online)
    end

    def user_auth        
      if current_user != @course.user
        redirect_to courses_path, alert: 'Oga, you don\'t own this course!'   
      end    
    end
    
    def user_manager_check
      if current_user.organizer == nil
        session[:return_to] ||= request.original_url
        redirect_to new_organizer_path, notice: "You need to create an Manager profile first." 
      else
        @user_organizer = current_user.organizer
      end 
    end

    def class_limits
      if current_user.courses.count > 1  && current_user.role != "admin"
        redirect_to @user_organizer, alert: 'You have uplaoded max amount of classes (2) for this account'   
      end    
    end 

    def activated_check
      if @course.course_state != "activated" && current_user != @course.user  
        redirect_to :back, alert: 'Oga, this course is not available'   
      end    
    end   
    
    def suspended_check
      if @course.course_state == "suspended"
        redirect_to :back, alert: 'Oga, this course is under admin investigation.' 
      end
    end
    
    
    def take_impression
      impressionist(@course,"impressions taken", unique: [:impressionable_id, :ip_address])
    end 
    
    def check_wizard
      if session[:setup_wizard]
         @course = current_user.courses.last
        redirect_to edit_course_path(@course), notice: "You were creating #{@course.title}. let's finish up."
      end
    end 
  
end
