class CoursePlansController < ApplicationController
  before_action :set_course_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_course

  # GET /course_plans
  # GET /course_plans.json
  def index
    @course_plans = CoursePlan.all
  end

  # GET /course_plans/1
  # GET /course_plans/1.json
  def show
  end

  # GET /course_plans/new
  def new
    @course_plan = CoursePlan.new
  end

  # GET /course_plans/1/edit
  def edit
  end

  # POST /course_plans
  # POST /course_plans.json
  def create
    @course_plan = @course.course_plans.build(course_plan_params)

    respond_to do |format|
      if @course_plan.save
    
        if session[:setup_wizard]
          session.delete(:setup_wizard)
        end
        if params[:type] == "Submit and add new"
          format.html { redirect_to new_course_course_plan_path(@course), notice: 'Plan was successfully created. Now create another.' }
        else
          format.html { redirect_to @course, notice: 'Plan was successfully created' }
        end
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_plans/1
  # PATCH/PUT /course_plans/1.json
  def update
    respond_to do |format|
      if @course_plan.update(course_plan_params)
        format.html { redirect_to @course, notice: 'Price plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_plans/1
  # DELETE /course_plans/1.json
  def destroy
    @course_plan.destroy
    respond_to do |format|
      format.html { redirect_to course_plans_url, notice: 'Price plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_plan
      @course_plan = CoursePlan.find(params[:id])
    end
    
    def set_course
      @course = Course.friendly.find(params[:course_id])
      @contact = @course.contact
      @refund_options = ["1 day", "7 days", "30 days", "No Refunds"]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_plan_params
      params.require(:course_plan).permit(:price, :class_name, :refund_policy, :course_id, :capacity, :description, :trade_by_barter)
    end
end
