class TutorsController < ApplicationController
  before_action :set_tutor, only: [:show, :edit, :update, :destroy]
	before_action :set_org, except: [:index, :show, :add_remove_tutor]
	before_action :authenticate_user!, except: [:index, :show]
	before_action :user_auth, only: [:edit, :update, :destroy, :new]

  # GET /tutors
  # GET /tutors.json
  def index
    @tutors = Tutor.all
  end

  # GET /tutors/1
  # GET /tutors/1.json
  def show
  end

  # GET /tutors/new
  def new
    @tutor = Tutor.new
    @tutor.build_social_link
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # GET /tutors/1/edit
  def edit
    if !@tutor.social_link
      @tutor.build_social_link
    end
    @organizer_courses -= @tutor.taught_courses
    
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # POST /tutors
  # POST /tutors.json
  def create
    
    @tutor = @user_organizer.tutors.build(tutor_params)
    
    respond_to do |format|
      if @tutor.save
        add_tutor
        remove_tutor
        format.html { redirect_to (session.delete(:return_to) || @user_organizer), notice: ' #{@tutor.name} was successfully added.' }
        format.json { render :show, status: :created, location: @tutor }
      else
        format.html { render :new }
        format.json { render json: @tutor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutors/1
  # PATCH/PUT /tutors/1.json
  def update
    respond_to do |format|
      if @tutor.update(tutor_params)
        add_tutor
        remove_tutor
        format.html { redirect_to (session.delete(:return_to) || @user_organizer), notice: " #{@tutor.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @tutor }
      else
        format.html { render :edit }
        format.json { render json: @tutor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutors/1
  # DELETE /tutors/1.json
  def destroy
    @tutor.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "#{@tutor.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def add_remove_tutor
    course = Course.friendly.find(params[:course_id]) 
    tutor = Tutor.find(params[:id])
    
    if !course.tutors.exists?(tutor) 
      course.tutors << tutor
      message = "#{tutor.name} was added to #{course.title}"
    else
      course.tutors.delete(tutor)
      message = "#{tutor.name} was removed from #{course.title}"
    end
    
    respond_to do |format|
      format.html { redirect_to :back, notice: message };
      format.json { head :no_content }
      format.js   { head :no_content }
      format.xml  { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tutor_params
      params.require(:tutor).permit(:name, {:tutored_courses => []}, {:untutored_courses => []}, :bio, :job_title, :website, :avatar, qualifications_attributes: [:id, :description, :_destroy], social_link_attributes: [:id, :facebook, :linkedin, :twitter, :googleplus, :pintrest, :instagram, :_destroy])
    end
    
    def add_tutor
          
      if params[:tutor][:tutored_courses]   
        add_courses = params[:tutor][:tutored_courses]
        add_courses_fin = add_courses.compact
      
        for add_course in add_courses_fin
          course = Course.find(add_course) 
          @tutor.taught_courses << course
        end
      end
        
    end
    
    def remove_tutor
          
      if params[:tutor][:untutored_courses]   
        remove_courses = params[:tutor][:untutored_courses]
        remove_courses_fin = remove_courses.compact
      
        for remove_course in remove_courses_fin
          course = Course.find(remove_course) 
          if @tutor.taught_courses.exists?(course)
             @tutor.taught_courses.delete(course)
          end
        end
      end
        
    end
    
    def set_org
      @user_organizer = Organizer.friendly.find(params[:organizer_id])
      @organizer_courses = @user_organizer.courses
    end
    
    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    def user_auth    
      if current_user != @user_organizer.user    
        redirect_to @course, alert: 'Oga, you don\'t own this course!' 
      end    
    end 

end
