class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy, :course_manager]
  before_action :authenticate_user!, except: [:show]
  before_action :user_auth, only: [:edit, :update, :destroy, :course_manager]  
  
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
  	 	  format.html { redirect_to session.delete(:return_to), notice: "#{@organizer.name} account was successfully created." }
        format.json { render :show, status: :created, location: @organizer}
      else
        @organizer.build_location
        format.html { render :new }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if current_user && current_user == @user_organizer.user
      @tutors = @organizer.tutors
      if @organizer.about
        @meta_description = @organizer.about
      else
        @meta_description = "organizer profile page for #{@organizer.name}"
      end
      @courses = Course.where(:organizer_id => @organizer.id).order(featured: :desc, completeness: :desc)
      
      #Required for addon form
      @order = OrganizerOrder.new
      @order.build_organizer_credit_order
      @promotable = @organizer.courses.active.where(:featured => false)
      
      unless @organizer.paystack_id
        create_paystack_profile
      end 
      
    else
      @courses = Course.active.where(:organizer_id => @organizer.id)
    end
    
   
  end

  def edit
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  def update
  	 respond_to do |format|
      if @organizer.update(organizer_params)
        update_paystack_profile
        format.html { redirect_to (session.delete(:return_to) || @organizer), notice: "#{@organizer.name} account was successfully updated." }
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
      format.html { redirect_to @user, notice: 'Organizer account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private 
  	def set_organizer
  	  if params[:organizer_id]
  	  	@organizer = Organizer.friendly.find(params[:organizer_id])
  		else
  		  @organizer = Organizer.friendly.find(params[:id])
  	  end
  	end 

  	def organizer_params
  		params.require(:organizer).permit(:name, :phone, :email, :website, :logo, :about, :broadcast_left, location_attributes: [:id, :address_line1, :address_line2, :city, :state, :country, :latitude, :longitude, :_destroy])
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
      OrganizerCreditBal.create!(:regular  => 0, :bonus => 50, :organizer_id => @organizer.id ) 
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

