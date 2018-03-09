class CourseDaysController < ApplicationController
    before_action :set_course_day, only: [:show, :edit, :update, :destroy]
    before_action :set_course, except: [:index, :show]
    before_action :organizer_check, except: [:index, :show]
    before_action :set_form_info, only: [:new, :create, :edit, :update]
    before_action :set_available_days, only: [:new, :edit]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :user_auth, only: [:edit, :update, :destroy, :new]
  
    # GET /course_days
    # GET /course_days.json
    def index
      @course_days = CourseDay.all
    end
  
    # GET /course_days/1
    # GET /course_days/1.json
    def show
    end
  
    # GET /course_days/new
    def new
      @course_day = CourseDay.new
    end
  
    # GET /course_days/1/edit
    def edit
      @available_weekdays << @course_day.weekday
      
    end
  
    # POST /course_days
    # POST /course_days.json
    def create
      @course_day = @course.course_days.build(course_day_params)
      respond_to do |format|
        if @course_day.save
          if @course.schedule_style != "Specific calender days"
            @course_day.update_attribute(:calendar_day, Date.today)
          end
          
          if session[:setup_wizard]
            session.delete(:setup_wizard)
            format.html { redirect_to @course, notice: "#{@course.title} now exists, Huzzah!. Now cross-check, edit and publish" }
          else
            format.html { redirect_to @course, notice: 'Day was successfully created' }
          end 
          format.json { render :show, status: :created, location: @course_day }
        else
          format.html { render :new }
          format.json { render json: @course_day.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /course_days/1
    # PATCH/PUT /course_days/1.json
    def update
      respond_to do |format|
        if @course_day.update(course_day_params)
          if session[:setup_wizard]
            session.delete(:setup_wizard)
            format.html { redirect_to @course, notice: "Huzzah! #{@course.title} exists. Remeber to cross-check before publishing the course." }
          else
            format.html { redirect_to @course, notice: 'course day was successfully updated' }
          end
          format.json { render :show, status: :ok, course_day: @course_day }
        else
          format.html { render :edit }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /course_days/1
    # DELETE /course_days/1.json
    def destroy
      @course_day.destroy
      respond_to do |format|
        format.html { redirect_to @course, notice: 'CourseDay was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_course_day
        @course_day = CourseDay.find(params[:id])
      end
      def set_form_info
        @states = ['Abia','Abuja (FCT)','Adamawa','Anambra','Akwa Ibom','Bauchi','Bayelsa','Benue','Borno','Cross River','Delta','Ebonyi','Enugu','Edo','Ekiti','Gombe','Imo','Jigawa','Kaduna','Kano','Katsina','Kebbi','Kogi','Kwara','Lagos','Nasarawa','Niger','Ogun','Ondo','Osun','Oyo','Plateau','Rivers','Sokoto','Taraba','Yobe','Zamfara']
        @prev_locations = @user_organizer.course_locations.select('distinct on (address_line2) *')
      end 
      # Never trust parameters from the scary internet, only allow the white list through.
      def course_day_params
        params.require(:course_day).permit(:weekday, :calendar_day, :location_id, :course_id, locations_attributes: [:id, :address_line1, :address_line2, :city, :state, :country, :latitude, :longitude, :_destroy,  course_times_attributes: [:id, :end_time, :start_time, :description, :_destroy]])
      end
      def set_course
        @course = Course.friendly.find(params[:course_id])
        @course_payment = @course.course_payment
      end
      
      def organizer_check
        if current_user.organizer == nil
          session[:return_to] ||= request.referer
          redirect_to new_organizer_path, notice: "You need to create an Organization first." 
        else
          @organizer = current_user.organizer
        end 
      end
      
      def set_available_days
        course_days = @course.course_days
        weekdays = ['Weekdays (Mon - Fri)','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday', 'Weekends (Sat & Sun)']
        @available_weekdays = []
        unavailable_weekdays = []
        
        for course_day in course_days do
          unavailable_weekdays << course_day.weekday
        end
        for weekday in weekdays do
          unless unavailable_weekdays.include?(weekday)
            @available_weekdays << weekday
          end
        end 
      end
  
      def user_auth    
        if current_user != @course.user    
          redirect_to @course, alert: 'Oga, you don\'t own this course!'  
        end    
      end 
end
