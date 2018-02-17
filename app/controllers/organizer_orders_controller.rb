class OrganizerOrdersController < ApplicationController
	before_action :set_organizer
	before_action :set_order, only: [:show, :edit, :update, :destroy]
	before_action :set_propmotable_courses, only: [:new, :edit, :update]
  before_action :authenticate_user!
  
  require 'paystack/objects/subaccounts.rb'
  require 'paystack.rb'
  
	def new 
    @order = OrganizerOrder.new
    @order.build_organizer_credit_order
	end
	

	def edit
    unless @order.organizer_credit_order
     @order.build_organizer_credit_order
    end 
	end
	
	def show 
    unless @order.total < 100
      post_order_process
    end 
    
    if @order.organizer_credit_order
      credit_order = @order.organizer_credit_order
      
      if credit_order.email_quantity
        @email_quantity = @order.organizer_credit_order.email_quantity
        @email_price = @order.organizer_credit_order.email_price
      else
        @email_quantity = 0
        @email_price = 0
      end
      
      if credit_order.text_quantity
        @text_quantity = @order.organizer_credit_order.text_quantity
        @text_price = @order.organizer_credit_order.text_price
      else
        @text_quantity = 0
        @text_price = 0
      end
      
    end
  
  	 @email_total =  @email_price * @email_quantity
  	 @text_total =  @text_price * @text_quantity
	end
	
	def update
    respond_to do |format|
      if @order.update(organizer_order_params)
        pre_order_process
        unless @order.total < 100
          obtain_auth_url
        end
        format.html { redirect_to organizer_organizer_order_url(@organizer, @order), notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
	
	
	def create
    @order = @organizer.organizer_orders.build(organizer_order_params)
    respond_to do |format|
      if @order.save
        pre_order_process
        unless @order.total < 100
          obtain_auth_url
        end
        format.html { redirect_to organizer_organizer_order_url(@organizer, @order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
	end

  
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to @organizer, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private 
  def organizer_order_params
		params.require(:organizer_order).permit(:total, :status, organizer_credit_order_attributes: [:id, :email_quantity, :email_price, :text_quantity, :text_price, :_destroy], course_promotions_attributes: [:id, :course_id, :price, :_destroy])
	end 
	
	def set_propmotable_courses
	  @promotable = @organizer.courses.active.where(:featured => false)
	end 
	
  def set_organizer
    @organizer = Organizer.friendly.find(params[:organizer_id])
  end
  
	def set_order
		@order = OrganizerOrder.find(params[:id])
	  @promotable = @organizer.courses.active.where(:featured => false)
    @last_email_credit_purchase = @organizer.credit_orders.where("email_quantity > ?", 0).last
    @last_text_credit_purchase = @organizer.credit_orders.where("text_quantity > ?", 0).last
	end
	
	def pre_order_process
	  
	  #calculate credit total
	  if @order.organizer_credit_order
      credit_order = @order.organizer_credit_order
      
      if credit_order.email_quantity
        email_total = credit_order.email_price * credit_order.email_quantity
      else
        email_total = 0
      end
      
      if credit_order.text_quantity 
        text_total = credit_order.text_price * credit_order.text_quantity
      else
        text_total = 0
      end
    end 
    
    #calclulate order total
    if @order.course_promotions
      promo_orders = @order.course_promotions
      promo_total = promo_orders.count * 7500
    else
      promo_total = 0
    end
    
    @order.total = promo_total + email_total + text_total
    @order.order_number = "#{@organizer.id}-#{current_user.id}-#{@order.id}"
    
    @order.save
  end 
  
  def obtain_auth_url
    paystackObj =  Paystack.new
    transactions = PaystackTransactions.new(paystackObj)
  	result = transactions.initializeTransaction(
  		:amount => @order.total * 100,
  		:email => @organizer.email,
  		:callback_url => "#{ENV["SKILLMENG_SITE"]}/organizers/#{@organizer.slug}/organizer_orders/#{@order.id}"
  		)
  		
  	@order.transaction_reference = result['data']['reference']
  	@order.access_code = result['data']['access_code']
  	@order.authorization_url = result['data']['authorization_url']
  	@order.save
  end
  
  def post_order_process
   #order_check
   unless @order.status == "success"
    paystackObj =  Paystack.new
  	transactions = PaystackTransactions.new(paystackObj)
  	result = transactions.verify(@order.transaction_reference)
  	
  	@order.status = result['data']['status']
  	@order.save
  	
  	#update_credit_bal
  	if  @order.status == "success" && @order.organizer_credit_order
  	  if @order.organizer_credit_order.email_quantity
    	  @organizer.organizer_credit_bal.email_regular += @order.organizer_credit_order.email_quantity
    	end
    	if @order.organizer_credit_order.text_quantity
    	  @organizer.organizer_credit_bal.text_regular += @order.organizer_credit_order.text_quantity
    	end
    	
  	  @organizer.organizer_credit_bal.save
  	end
  	
  	#update_course_promotion
  	if  @order.status == "success" && !@order.course_promotions.empty?
  	  course = Course.find(@order.course_promotions.last.course_id)
  	  course.update_attribute(:featured, true)
  	end
  	
   end 
  end 
  
  def user_check
    if current_user && current_user != @organizer.user
      redirect_to @organizer, alert: "Oga, you cannot make purchases on this account!"   
    end
  end
end
