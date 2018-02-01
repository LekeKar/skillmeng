class AboutsController < ApplicationController
  before_action :set_about, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index, :show]
  before_action :check_about_exists, only: [:create, :new]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :user_auth, only: [:edit, :update, :destroy, :new]  

  def new
  	@about = About.new
  end

  def create
  
    @about = @course.build_about(about_params) 
  	
  	respond_to do |format|

  	  if @about.save
  	    if session[:setup_wizard]
  	      session[:setup_wizard] = "about"
  	 	    format.html { redirect_to new_course_contact_path(@course), notice: 'About content was successfully created.' }
  	 	  else
  	 	    format.html { redirect_to @course, notice: 'About content was successfully created.' }
  	 	  end 
  	 	  
        format.json { render :show, status: :created, location: @course}
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
  	 respond_to do |format|
      if @about.update(about_params)
        if session[:setup_wizard]
          session[:setup_wizard] = "about"
          if @contact
  	 	      format.html { redirect_to edit_course_contact_path(@course, @contact), notice: 'About content was successfully updated.' }
    	 	  else
    	 	    format.html { redirect_to new_course_contact_path(@course), notice: 'About content was successfully updated.' }
    	 	  end 
    	  else
          format.html { redirect_to @course, notice: 'About content was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @about.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'About content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private 
  	def set_about
  		@about = About.find(params[:id])
  	end
  	
  	def check_about_exists
      if !@course.about.nil?
        @about = @course.about
        redirect_to edit_course_about_path(@course, @about), notice: "About Info for #{@course.title} already exists. Redirected to edit."
      end 
    end 

  	def about_params
  		params.require(:about).permit(:content, requirements_attributes: [:id, :description, :_destroy], checklist_items_attributes: [:id, :description, :_destroy], course_rewards_attributes: [:id, :name, :acronym, :description, :_destroy])
  	end 

    def set_course
      @course = Course.friendly.find(params[:course_id])
      @contact = @course.contact
    end

    def user_auth    
      if current_user != @course.user    
        redirect_to @course, alert: 'Oga, you don\'t own this course!'   
      end    
    end   
  end 


