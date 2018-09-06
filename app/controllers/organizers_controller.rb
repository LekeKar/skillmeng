class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy, :purchases]
  before_action :authenticate_user!, except: [:show]
  before_action :banks, only: [:new, :edit, :create, :update]
  before_action :user_auth, only: [:edit, :update, :destroy, :purchases]  
  
  require 'paystack/objects/subaccounts.rb'
  require 'paystack.rb'

  def new
  	@organizer = Organizer.new
  	@organizer.build_location
  	@organizer.build_org_bank_info
  end

  def create
  	@organizer = current_user.build_organizer(organizer_params)
  	
  	respond_to do |format|
      if @organizer.save
        create_paystack_cust_profile
        create_paystack_org_account
        create_credit_bal
        @organizer.org_bank_info.save
  	 	  format.html { redirect_to new_course_path, notice: "#{@organizer.name} account was successfully created." }
        format.json { render :show, status: :created, location: @organizer}
      else
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
      title: "Manager | #{@organizer.name}",
      type: 'website',
      image: @organizer.logo.url(:medium),
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
        create_paystack_cust_profile
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
    unless @organizer.org_bank_info
    	@organizer.build_org_bank_info
    end
  end

  def update
  	respond_to do |format|
      if @organizer.update(organizer_params)
        update_paystack_cust_profile
        update_paystack_org_account
        
        if @organizer.name_changed?
          update_course_org
        end
        
        format.html { redirect_to (@organizer), notice: "#{@organizer.name} account was successfully updated." }
        format.json { render :show, status: :ok, location: @organizer }
      else
        unless @organizer.build_org_bank_info
          @organizer.build_org_bank_info
        end 
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
  		params.require(:organizer).permit(:name, :phone, :email, :website, :logo, :about, 
  		                                  location_attributes: [:id, :address_line1, :address_line2, :city, :state, :country, :latitude, :longitude, :_destroy], 
  		                                  org_bank_info_attributes: [:id, :bank_name, :bank_account_number, :bank_account_name, :paystack_id, :paystack_plan, :_destroy])
  	end 
  	
  	def user_auth
      if current_user.id != @organizer.user_id    
        redirect_to root_path, alert: "Oga, you are not #{@organizer.name}!"  
      end    
    end
  	
  # Paystack organizer profile 
  	def create_paystack_org_account
  	  @user_fullname = "#{current_user.fname.try(:titlize)} #{current_user.lname.try(:titlize)}"
      paystack =  Paystack.new
      subaccounts = PaystackSubaccounts.new(paystack)
      subaccount_result = subaccounts.create(
      
        :business_name => @organizer.name.strip,
        :settlement_bank => @organizer.org_bank_info.bank_name.strip,
        :account_number => @organizer.org_bank_info.bank_account_number.strip,
        :primary_contact_name => @user_fullname,
        :primary_contact_email => @organizer.email,
        :primary_contact_phone => @organizer.phone,
        :percentage_charge => 3.75
      )
      
      @organizer.org_bank_info.paystack_id = subaccount_result['data']['subaccount_code']
  	end
  	
  	def update_paystack_org_account
  	
  	  if @organizer.org_bank_info
          paystack = Paystack.new
          subaccount_id = @organizer.org_bank_info.paystack_id
          subaccounts = PaystackSubaccounts.new(paystack)
          # Updating primary contact name and email of subaccount
          result = subaccounts.update(
              subaccount_id,
              :business_name => @organizer.org_bank_info.bank_account_name.strip,
              :settlement_bank => @organizer.org_bank_info.bank_name.strip,
              :account_number => @organizer.org_bank_info.bank_account_number.strip
          )
      end 
    end 
    
    # Paystack customer profile
    def create_paystack_cust_profile
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
    
    def update_paystack_cust_profile
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
    
    def create_credit_bal
      OrganizerCreditBal.create!(:email_regular  => 0, :email_bonus => 50, :text_regular  => 0, :text_bonus => 40,  :organizer_id => @organizer.id ) 
    end 
    
    def update_course_org
      for course in @organizer.courses
        course.update_atribute(:tutor, organizer.name)
      end
    end
    
    def banks
      paystack =  Paystack.new
      banks = PaystackBanks.new(paystack)
      result = banks.list
      banks = result['data']
    
      @bank_name ||= [] 
      banks.each do |bank|
        @bank_name.push(bank['name'])
      end
    end 
    
    
end 


