class AnnouncementMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.announcement_mailer.course_news.subject
  #
  def course_news(user, announcement)
    @user = user
    @announcement = announcement
    @course = Course.find(@announcement.sender)
    @organizer = @course.organizer
    
    @body = @announcement.body
    email_with_name = %("#{@user.fname} #{@user.lname}" <#{@user.email}>)
    mail(to: email_with_name, subject: @announcement.subject, from: "no_reply@skillmeng.com")
  end
  
  def credit_refill(org, amount)
    @org = org
    @amount = amount
    email_with_name = %("#{@org.name}" <#{@org.email}>)
    mail(to: email_with_name, subject: "Bonus email credit refilled", from: "no_reply@skillmeng.com")
  end
  
  def course_report(course)
    @course = course
    mail(to:"admin@skillmeng.com", subject: "Users are reporting #{@course.title}", from: "no_reply@skillmeng.com")
  end
  
  
  def barter_request(user, trade_offer)
    @user = user
    @trade_offer = trade_offer
    @offered_course = Course.find(@trade_offer.sender_trade_courses)
    @offered_course_reviews = @offered_course.reviews
      if @offered_course_reviews.blank?
        @avg_review = 0
      else
        @avg_review = @offered_course_reviews.average(:rating).present? ? @offered_course_reviews.average(:rating).round(2) : 0
      end 
    
    @requested_course = Course.find(@trade_offer.course_id)
    @course_payment = @requested_course.course_payment
    
    @additional_info = @trade_offer.additional_info
    email_with_name = %("#{@user.fname} #{@user.lname}" <#{@user.email}>)
    mail(to: email_with_name, subject: "Barter offer from #{@offered_course.organizer.name}", from: "no_reply@skillmeng.com")
  end
  
  def barter_response(user, trade_offer, ans)
    @user = user
    @ans = "#{ans}"
    @trade_offer = trade_offer
    @offered_course = Course.find(@trade_offer.sender_trade_courses)
    @offered_course_reviews = @offered_course.reviews
      if @offered_course_reviews.blank?
        @avg_review = 0
      else
        @avg_review = @offered_course_reviews.average(:rating).present? ? @offered_course_reviews.average(:rating).round(2) : 0
      end 
    
    @requested_course = Course.find(@trade_offer.course_id)
    @course_payment = @requested_course.course_payment
    
    @additional_info = @trade_offer.additional_info
    email_with_name = %("#{@user.fname} #{@user.lname}" <#{@user.email}>)
    mail(to: email_with_name, subject: "Barter offer was #{ans}", from: "no_reply@skillmeng.com")
  end
end

