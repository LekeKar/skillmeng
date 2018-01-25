class GalleryPicsController < ApplicationController
  before_action :set_gallery_pic, only: [:show, :edit, :update, :destroy]
  before_action :set_course, except: [:index]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :user_auth, only: [:edit, :update, :destroy, :new]
  before_action :gallery_limits, only: [:new, :create]

  # GET /gallery_pics
  # GET /gallery_pics.json
  def index
    @gallery_pics = GalleryPic.all
  end

  # GET /gallery_pics/new
  def new
    @gallery_pic = GalleryPic.new
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # GET /gallery_pics/1/edit
  def edit
    session[:return_to] ||= request.env["HTTP_REFERER"] || 'none'
  end

  # POST /gallery_pics
  # POST /gallery_pics.json
  def create

    @gallery_pic = @course.gallery_pics.build(gallery_pic_params)
  
    respond_to do |format|
      if @gallery_pic.save
        format.html { redirect_to (session.delete(:return_to) || @course), notice: 'Gallery pic was successfully created.' }
        format.json { render :show, status: :created, location: @gallery_pic }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /gallery_pics/1
  # PATCH/PUT /gallery_pics/1.json
  def update
    respond_to do |format|
      if @gallery_pic.update(gallery_pic_params)
        format.html { redirect_to (session.delete(:return_to) || @course), notice: 'Gallery pic was successfully updated.' }
        format.json { render @course, status: :ok, location: @gallery_pic }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gallery_pics/1
  # DELETE /gallery_pics/1.json
  def destroy
    @gallery_pic.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Gallery pic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery_pic
      @gallery_pic = GalleryPic.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gallery_pic_params
      params.require(:gallery_pic).permit(:caption, :image)
    end

    def user_auth    
      if current_user != @course.user    
        redirect_to @course, alert: 'Oga, you don\'t own this course!'   
      end    
    end 

    def gallery_limits    
      if @course.gallery_pics.count > 8  
        redirect_to course_gallery_path(@course), alert: 'You have uplaoded max amount of pictures for this class'   
      end    
    end 
end