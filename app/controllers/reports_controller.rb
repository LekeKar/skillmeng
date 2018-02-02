class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index, :show]
  before_action :user_check, only: [:new] 
  before_action :authenticate_user!

    def new 
    	@report = Report.new
  	end
  	
    def show
  	end

  	def edit
  	end

  	def create
    
      @report = @course.reports.build(report_params)
      @report.user_id = current_user.id
      
      if @course.reports % 5 == 0
		    AnnouncementMailer.course_report(@course).deliver_now
		    @course.update_atribute(:state, "suspended")
      end 
      

	    respond_to do |format|
	      if @report.save
	        format.html { redirect_to @course, notice: 'Report was successfully submited.' }
	        format.json { render :show, status: :created, location: @report }
	      else
	        format.html { render :new }
	        format.json { render json: @course.errors, status: :unprocessable_entity }
	      end
	    end
  	end

  	def destroy
	    @report.destroy
	    respond_to do |format|
	      format.html { redirect_to @course, notice: 'Report was successfully destroyed.' }
	      format.json { head :no_content }
	    end
	  end


	private
    # Use callbacks to share common setup or constraints between actions.
    def report_params
      params.require(:report).permit(:reason, :explanation, :status, :admin_action)
    end

    def set_report
      @report = Report.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end
    
    def user_check
      if current_user == @course.user
        redirect_to course_path(@course, visitor: "visitor"), alert: "Oga, you can't report your own course!"   
      end
    end

end 