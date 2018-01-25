require 'test_helper'

class AnnouncementMailerTest < ActionMailer::TestCase
  test "course_news" do
    mail = AnnouncementMailer.course_news
    assert_equal "Course news", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
