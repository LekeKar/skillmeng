class CoursePaymentsController < ApplicationController
  before_action :set_course_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index, :show]
  before_action :check_payment_info_exists, only: [:create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :banks, only: [:new, :edit, :create, :update]
  before_action :user_auth, only: [:edit, :update, :destroy, :new, :create] 

  require 'paystack/objects/subaccounts.rb'
  require 'paystack.rb'

  # GET /course_payments
  # GET /course_payments.json

  # GET /course_payments/1
  # GET /course_payments/1.json


  # GET /course_payments/new
  def new
    @course_payment = CoursePayment.new
    @user_fullname = "#{current_user.fname.try(:titlize)} #{current_user.lname.try(:titlize)}"
  end

  # GET /course_payments/1/edit
  def edit
  end

  # POST /course_payments
  # POST /course_payments.json
  def create
    @course_payment = @course.build_course_payment(course_payment_params) 
    @user_fullname = "#{current_user.fname.try(:titlize)} #{current_user.lname.try(:titlize)}"

    paystack =  Paystack.new
    subaccounts = PaystackSubaccounts.new(paystack)
    subaccount_result = subaccounts.create(
      
        :business_name => @course.title.strip,
        :settlement_bank => @course_payment.bank_name.strip,
        :account_number => @course_payment.bank_account_number.strip,
        :primary_contact_name => @user_fullname,
        :primary_contact_email => current_user.email,
        :primary_contact_phone => current_user.tel,
        :percentage_charge => 3.75
    )
    
    respond_to do |format|
      if @course_payment.save
        @course_payment.paystack_id = subaccount_result['data']['subaccount_code']
        @course_payment.save
        
  	    if session[:setup_wizard]
  	      session[:setup_wizard] = "payment"
          format.html { redirect_to new_course_course_day_path(@course), notice: 'Payment info was successfully created.' }
        else
          format.html { redirect_to @course, notice: 'Payment info was successfully created.' }
        end
        format.json { render :show, status: :created, location: course_payment_path(@course) }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /course_payments/1
  # PATCH/PUT /course_payments/1.json
  def update
    respond_to do |format|
      if @course_payment.update(course_payment_params)

        if @course_payment.paystack_id
          paystack = Paystack.new
          subaccount_id = @course_payment.paystack_id
          subaccounts = PaystackSubaccounts.new(paystack)
          # Updating primary contact name and email of subaccount
          result = subaccounts.update(
              subaccount_id,
              :business_name => @course_payment.bank_account_name.strip,
              :settlement_bank => @course_payment.bank_name.strip,
              :account_number => @course_payment.bank_account_number.strip
          )
        end 
        
        if session[:setup_wizard]
          session[:setup_wizard] = "payment"
          if @course_day
  	 	      format.html { redirect_to edit_course_course_day_path(@course, @course_day), notice: 'About content was successfully updated.' }
    	 	  else
    	 	    format.html { redirect_to new_course_course_day_path(@course), notice: 'About content was successfully updated.' }
    	 	  end 
    	  else
          format.html { redirect_to @course, notice: 'Barter info was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: course_payment_path(@course) }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_payments/1
  # DELETE /course_payments/1.json
  def destroy
    @course_payment.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Payment info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_payment
      @course_payment = CoursePayment.find(params[:id])
    end
    
    # used in wizard
    def check_payment_info_exists
      if !@course.course_payment.nil?
        @course_payment = @course.course_payment
        redirect_to edit_course_course_payment_path(@course, @course_payment), notice: "Payment info for #{@course.title} already exists. Redirected to edit."
      end 
    end 
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_payment_params
      params.require(:course_payment).permit(:refund_instruction, :payment_instruction, :bank_name, :bank_account_number, :bank_account_name, :paystack_id, :paystack_plan, :trade_by_barter, :course_id, :seek_course1, :seek_course2, :seek_course3, course_prices_attributes: [:id, :price, :quantity, :unit, :explaination, :_destroy])
    end


    def set_course
      @course = Course.friendly.find(params[:course_id])
      @contact = @course.contact
      @course_day = @course.course_days.last
      @available_accounts = @user_organizer.course_payments.select('distinct on (bank_account_number) *')
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

    def user_auth    
      if current_user != @course.user    
        redirect_to @course, alert: 'Oga, you don\'t own this course!'  
      end    
    end 
end




