class WelcomeController < ApplicationController
  before_action :set_resources, only: [:home]  

  
  def home
  	if current_user
  		redirect_to courses_path
  	end
  	  @meta_description = "Welcome to Skillmeng, an online platform for finding \"offline\" courses in Nigeria."
  end

  def about
  end
  
  private
    
    def set_resources
      @slider_pic = HomepageSliderCourse.order("RANDOM()").first
      @categories = [ "sport/fitness", "photography/film", "food/drink","fashion/style", "hair/beauty", "languages", "music", "art/crafts", "design", "technology", "professional", "lifestyle", "religion", "just for fun" ]
      @states = ['Abia','Abuja (FCT)','Adamawa','Anambra','Akwa Ibom','Bauchi','Bayelsa','Benue','Borno','Cross River','Delta','Ebonyi','Enugu','Edo','Ekiti','Gombe','Imo','Jigawa','Kaduna','Kano','Katsina','Kebbi','Kogi','Kwara','Lagos','Nasarawa','Niger','Ogun','Ondo','Osun','Oyo','Plateau','Rivers','Sokoto','Taraba','Yobe','Zamfara']
      @category_count = Hash.new
      
      for category in @categories
        var = "#{category}"
        courses = Course.active.where(:category => var)
        @category_count[var] = courses
      end
    end
end