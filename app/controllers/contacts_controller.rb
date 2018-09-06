class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index, :show]
  before_action :check_contact_exists, only: [:create]
  before_action :organizer_check, except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :user_auth, only: [:edit, :update, :destroy, :new]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.build_social_link
  end

  # GET /contacts/1/edit
  def edit
    if !@contact.social_link
      @contact.build_social_link
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create

    @contact = @course.build_contact(contact_params) 

    respond_to do |format|
      if @contact.save
  	    if session[:setup_wizard]
  	      session[:setup_wizard] = "contact"
          format.html { redirect_to new_course_course_plan_path(@course), notice: 'Contact was successfully created.' }
        else
          format.html { redirect_to @course, notice: 'Contact was successfully created.' }
        end
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        if session[:setup_wizard]
          session[:setup_wizard] = "contact"
          if @course_plan
  	 	      format.html { redirect_to edit_course_course_plan_path(@course, @course_plan), notice: 'Contact was successfully updated.' }
    	 	  else
    	 	    format.html { redirect_to edit_course_course_plan_path(@course), notice: 'Contact was successfully updated.' }
    	 	  end
    	  else
          format.html { redirect_to @course, notice: 'Contact was successfully updated.' }
        end
        
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end
    
    def check_contact_exists
      if !@course.contact.nil?
        @contact = @course.contact
        redirect_to edit_course_contact_path(@course, @contact), notice: "Contact Info for #{@course.title} already exists. Redirected to edit."
      end 
    end 
    

    def set_course
      @course = Course.friendly.find(params[:course_id])
      @about = @course.about
    end
    
    def organizer_check
      if current_user.organizer == nil
        session[:return_to] ||= request.referer
        redirect_to new_organizer_path, notice: "You need to create an Organization first." 
      else
        @organizer = current_user.organizer
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:contact_name, :tel1, :tel2, :tel3, :email, :course_id, :tutor_website, social_link_attributes: [:id, :facebook, :linkedin, :twitter, :googleplus, :pintrest, :instagram, :_destroy])
    end

    def user_auth    
      if current_user != @course.user    
        redirect_to @course, alert: 'Oga, you don\'t own this course!'   
      end    
    end
    
end
