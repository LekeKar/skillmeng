class CourseRequestsController < ApplicationController
  before_action :set_course_request, only: [:show, :edit, :update, :destroy]
  before_action :set_course
  before_action :course_active_check, only: [:new] 
  before_action :user_check, only: [:new] 
  before_action :authenticate_user!
  before_action :user_auth, only: [:index, :show]

  # GET /course_requests
  # GET /course_requests.json
  def index
    @course_requests = CourseRequest.all
  end

  # GET /course_requests/1
  # GET /course_requests/1.json
  def show
  end

  # GET /course_requests/new
  def new
    @course_request = CourseRequest.new
  end

  # GET /course_requests/1/edit
  def edit
  end

  # POST /course_requests
  # POST /course_requests.json
  def create
    @course_request =  @course.course_requests.build(course_request_params)
    @course_request.user_id = current_user.id
    @course_request.reciever_id = @course.user_id


    respond_to do |format|
      if @course_request.save
        AnnouncementMailer.barter_request(@course.user, @course_request).deliver_now
        format.html { redirect_to @course, notice: 'Barter request successfully sent.' }
        format.json { render :show, status: :created, location: @course_request }
      else
        format.html { render :new }
        format.json { render json: @course_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_requests/1
  # PATCH/PUT /course_requests/1.json
  def update
    respond_to do |format|
      if @course_request.update(course_request_params)
        format.html { redirect_to @course, notice: 'Barter reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_request }
      else
        format.html { render :edit }
        format.json { render json: @course_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_requests/1
  # DELETE /course_requests/1.json
  def destroy
    @course_request.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Barter request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_read
    @course_request = CourseRequest.find(params[:course_request_id])
    @course_request.toggle!(:owner_read)

    respond_to do |format|

      if @course_request.save
        format.html { redirect_to request.referer, notice: "changes successfully made"}
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end  
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_request
      @course_request = CourseRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_request_params
      params.require(:course_request).permit(:sender_trade_courses, :sender_email, :sender_phone, :additional_info, :status, :owner_read, :reciever_id, :user_id, :course_id)
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
      @class_payment = @course.course_payment
    end

    def user_auth    
      if current_user != @course.user
        redirect_to @course, alert: 'Oga, you don\'t own this course!' 
      end    
    end
    
    def course_active_check
      if current_user.courses.active.empty?
        redirect_to :back, alert: 'Oga, you don\'t have any active course to trade' 
      end 
    end

    def user_check
      if current_user == @course.user
        redirect_to course_path(@course, visitor: "visitor"), alert: "Oga, you can't trade your own course!"   
      end
    end  
end
