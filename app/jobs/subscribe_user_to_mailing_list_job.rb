class SubscribeUserToMailingListJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gb = Gibbon::Request.new
    gb.lists(ENV["MAILCHIMP_LIST_ID"]).members.create(body: {email_address: user.email, status: "subscribed", merge_fields: {FNAME: user.fname, LNAME: user.lname}})
  	rescue Gibbon::MailChimpError => e
    return nil, :flash => { error: e.message }
  end
end
