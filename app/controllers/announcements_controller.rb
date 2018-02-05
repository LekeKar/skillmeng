class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update, :destroy, :email_broadcast]
  before_action :set_course
  before_action :set_organizer, only: [:new, :edit] 
  before_action :suspended_check, only: [:new, :edit] 
  before_action :user_auth, only: [:edit, :new]

  # GET /announcements
  # GET /announcements.json
  def index
    @announcements = Announcement.course.where(:sender => @course).order('created_at DESC').page(params[:page]).per_page(9)
  end

  # GET /announcements/1
  # GET /announcements/1.json
  
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
    @total_email_credit = @organizer.organizer_credit_bal.email_regular + @organizer.organizer_credit_bal.email_bonus
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # GET /announcements/1/edit
  def edit
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # POST /announcements
  # POST /announcements.json
  def create
    @announcement = Announcement.new(announcement_params)
    
    respond_to do |format|
      if @announcement.save
          post_news
        if @announcement.broadcast
          send_email
        end
        format.html { redirect_to (session.delete(:return_to) || @course), notice: 'Announcement was successfully created.' }
        format.json { render :show, status: :created, location: @announcement }
      else
        @course = Course.friendly.find(params[:course])
        @organizer = Organizer.find(@course.organizer)
        format.html { render :new }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1
  # PATCH/PUT /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        announcement_link_check
        format.html { redirect_to (session.delete(:return_to) || :back), notice: 'Announcement was successfully updated.' }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.json
  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Announcement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def email_broadcast
    send_email
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Email broadcast was successful' }
      format.json { head :no_content }
    end
  end
 

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end
  
  def announcement_link_check
    if @announcement.action_link && @announcement.action_link == "http://"
		  @announcement.update_attribute(:action_type, "view course")
		end
  end
  
  def send_email
    total_email_list = @course.favorited_by.subscribeable.count
    recipients = @course.favorited_by.subscribeable
    credit_bal = @user_organizer.organizer_credit_bal
    
    #deduct email bal
    if credit_bal.email_bonus <= total_email_list
      credit_bal.email_bonus = 0
      credit_bal.email_regular = credit_bal.email_regular - ( total_email_list - credit_bal.email_bonus)
    else
      credit_bal.email_bonus -= total_email_list 
    end
    # send email and save bal
    for recipient in recipients
      AnnouncementMailer.course_news(recipient, @announcement).deliver_now
    end
    
    credit_bal.save
  end
  
  def user_auth    
    if current_user != @course.user    
      redirect_to @course, alert: 'Oga, you don\'t own this course!'   
    end    
  end  
  
  def set_course
    if params[:course]
      @course = Course.friendly.find(params[:course])
    elsif @announcement && @announcement.sender_type == "course" 
      @course = Course.friendly.find(@announcement.sender)
    end
  end
  
  def set_organizer
    if @course.organizer
      @organizer = Organizer.find(@course.organizer)
    end
  end 
  
  def post_news
    @course = Course.friendly.find(@announcement.sender)
    if @announcement.action_link && @announcement.action_link != "http://"
		  @announcement.update_attribute(:action_type, "link")
		else
		  @announcement.update_attribute(:action_type, "view course")
		end
		@announcement.action_id = @course.id
		@announcement.save
    @announcement.users << @course.favorited_by.broadcastable
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def announcement_params
    params.require(:announcement).permit(:subject, :body, :sender_type, :sender, :action_link, :sender_type, :photo, :broadcast)
  end
  
  def suspended_check
    if @course.course_state == "suspended"
      redirect_to :back, alert: 'Oga, this course is under admin investigation.' 
    end
  end
end
