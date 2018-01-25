
class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :user_auth, only: [:edit, :update, :destroy] 
  before_action :oga_check, only: [:edit, :new, :update] 
  before_action :duplicate_check, only: [:edit, :new, :update] 

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # GET /reviews/1/edit
  def edit
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # POST /reviews
  # POST /reviews.json
  def create
      @review = @course.reviews.build(review_params)
      @review.user_id = current_user.id
     
    respond_to do |format|
      if @review.save
        format.html { redirect_to (session.delete(:return_to) || @course), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to (session.delete(:return_to) || root_path), notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :comment, :anonymous, :user_id, :course_id)
    end

    def user_auth    
      if current_user != @review.user
        redirect_to @course, alert: 'Oga, that is not your review!'   
      end    
    end

    def oga_check
      if current_user == @course.user
        redirect_to @course, alert: "Oga, you can\'t review your own course!"   
      end 
    end
    
    def duplicate_check
      if  @course.reviews.where(:user_id => current_user.id).exists?
        redirect_to @course, alert: "Oga, you can only review once!"
      end
    end
end
