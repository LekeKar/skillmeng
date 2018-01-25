# Preview all emails at http://localhost:3000/rails/mailers/announcement_mailer
class AnnouncementMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/announcement_mailer/course_news
  def course_news
    user = User.find(1)
    announcement = Announcement.find(71)
    AnnouncementMailer.course_news(user, announcement)
  end
  
  def credit_refill
    org = Organizer.find(11)
    AnnouncementMailer.credit_refill(org)
  end
  
  def course_report
    course = Course.find(1)
    AnnouncementMailer.course_report(course)
  end
  
  def barter_request
    user = User.find(1)
    trade_offer = CourseRequest.find(34)
    AnnouncementMailer.barter_request(user, trade_offer)
  end
  
  def barter_response
    user = User.find(2)
    trade_offer = CourseRequest.find(34)
    ans = "accepted"
    AnnouncementMailer.barter_response(user, trade_offer, ans)
  end

end
