# Preview all emails at http://localhost:3000/rails/mailers/announcement_mailer
class AnnouncementMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/announcement_mailer/course_news
  def course_news
    user = User.find(1)
    announcement = Announcement.find(1)
    AnnouncementMailer.course_news(user, announcement)
  end
  
  def credit_refill
    amount = {email: 50, text: 10}
    org = Organizer.find(2)
    AnnouncementMailer.credit_refill(org, amount)
  end
  
  def course_report
    course = Course.find(1)
    AnnouncementMailer.course_report(course)
  end
  
  def barter_request
    user = User.find(1)
    trade_offer = CourseRequest.find(1)
    AnnouncementMailer.barter_request(user, trade_offer)
  end
  
  def barter_response
    user = User.find(2)
    trade_offer = CourseRequest.find(1)
    ans = "accepted"
    AnnouncementMailer.barter_response(user, trade_offer, ans)
  end

end
