class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy, :purchases]
  before_action :authenticate_user!, except: [:show]
  before_action :user_auth, only: [:edit, :update, :destroy, :purchases]  
  
  require 'paystack/objects/subaccounts.rb'
  require 'paystack.rb'

  def new
  	@organizer = Organizer.new
  	@organizer.build_location
  end

  def create
  	@organizer = current_user.build_organizer(organizer_params)
  	
  	respond_to do |format|
      if @organizer.save
        create_paystack_profile
        create_credit_bal
  	 	  format.html { redirect_to new_course_path, notice: "#{@organizer.name} account was successfully created." }
        format.json { render :show, status: :created, location: @organizer}
      else
        @organizer.build_location
        format.html { render :new }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    # capture metadescription
    if @organizer.about
      @meta_description = @organizer.about
    else
      @meta_description = "#{@organizer.name}, is a course organizer on Skillmeng"
    end
    
    # capture metadescription
    @og_properties = {  
      title: "#{@organizer.name}",
      type: 'website',
      image: @organizer.logo.url(:large),
      url: "#{ENV["SKILLMENG_SITE"]}/organizers/#{@organizer.slug}",
      fb: ENV["FACEBOOK_ID"],
      description: @meta_description
    }
    
    if @user_organizer
      @tutors = @organizer.tutors
      @courses = Course.where(:organizer_id => @organizer.id).order(featured: :desc, completeness: :desc)
      
      #Required for addon form
      @order = OrganizerOrder.new
      @order.build_organizer_credit_order
      @promotable = @organizer.courses.active.where(:featured => false)
      @last_email_credit_purchase = @organizer.credit_orders.where("email_quantity > ?", 0).last
      @last_text_credit_purchase = @organizer.credit_orders.where("text_quantity > ?", 0).last
      
      unless @organizer.paystack_id
        create_paystack_profile
      end 
      
    else
       @courses = Course.active.where(:organizer_id => @organizer.id)
       @tutors = @organizer.tutors
    end
  end
  
  def purchases
    @all_orders = @organizer.organizer_orders.successful.order(created_at: :desc).page(params[:page]).per_page(12)
  end

  def edit
  end

  def update
  	respond_to do |format|
      if @organizer.update(organizer_params)
        update_paystack_profile
        
        if @organizer.name_changed?
          update_course_org
        end
          
        
        format.html { redirect_to (@organizer), notice: "#{@organizer.name} account was successfully updated." }
        format.json { render :show, status: :ok, location: @organizer }
      else
        format.html { render :edit }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Manager account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private 
  	def set_organizer
  	  if params[:id]
  	    @organizer = Organizer.friendly.find(params[:id])	
  		else
  		  @organizer = Organizer.friendly.find(params[:organizer_id])
  	  end
  	end 

  	def organizer_params
  		params.require(:organizer).permit(:name, :phone, :email, :website, :logo, :about, location_attributes: [:id, :address_line1, :address_line2, :city, :state, :country, :latitude, :longitude, :_destroy])
  	end 

    def user_auth
      if current_user.id != @organizer.user_id    
        redirect_to root_path, alert: "Oga, you are not #{@organizer.name}!"  
      end    
    end   
    
    def create_paystack_profile
      paystackObj = Paystack.new
      customers = PaystackCustomers.new(paystackObj)
    	result = customers.create(
    		:first_name => @organizer.name,
    		:last_name => @organizer.id,
    		:phone => @organizer.phone,
    		:email => @organizer.email
    	)
    	@organizer.paystack_id = result['data']['id']
    	@organizer.save
    end 
    
    def create_credit_bal
      OrganizerCreditBal.create!(:email_regular  => 0, :email_bonus => 50, :text_regular  => 0, :text_bonus => 10,  :organizer_id => @organizer.id ) 
    end 
    
    def update_course_org
      for course in @organizer.courses
        course.update_atribute(:tutor, organizer.name)
      end
    end
    
    def update_paystack_profile
      paystackObj = Paystack.new
      customers = PaystackCustomers.new(paystackObj)
      result = customers.update(
    		@organizer.paystack_id,
    		:first_name => @organizer.name,
    		:last_name => @organizer.id,
    		:phone => @organizer.phone,
    		:email => @organizer.email
    	)
    end 
end 


