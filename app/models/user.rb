class User < ActiveRecord::Base

  before_validation :strip_blanks
  after_create :subscribe_user_to_mailing_list

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
  
   ROLES = %i[admin trial pro banned]
  
  has_many :courses, dependent: :destroy
  has_one  :organizer, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :course_requests, dependent: :destroy
  has_many :alerts, dependent: :destroy # just the 'relationships'
  has_many :announcements, through: :alerts


  # Favorited by users
  has_many :favorite_courses, dependent: :destroy # just the 'relationships'
  has_many :favorites, through: :favorite_courses, source: :course # the actual courses a user favorites

  # Profile pic
  has_attached_file :avatar, styles:{ avatar: "300x300#"}, default_url: "/images/:style/missing1.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates_attachment_size :avatar, :in => 0.megabytes..4.megabytes
  
  

  validates :fname, :presence => {:message => 'User must have first name'}
  validates :lname, :presence => {:message => 'User must have Last name'}
  validates :tel,   :numericality => true, 
                    :length => { is: 11},
                    uniqueness: true
  
  # facebook oath
  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        auth.provider = "Facebook"
        user = User.create!(
          provider: auth.provider, 
          email: auth.info.email,
          fname: auth.extra.raw_info.first_name,
          lname: auth.extra.raw_info.last_name,
          password: Devise.friendly_token[0,20],
          confirmed_at: Time.zone.now # Skips confirmation
          )
      end
    end
  end
  
  # google oath
  def self.find_for_google_oauth2(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(fname: data["first_name"],
        email: data["email"],
        lname: data["last_name"],
        provider: "Google",
        password: Devise.friendly_token[0,20],
        confirmed_at:Time.zone.now # Skips confirmation
        )
      end
    end
  end
     
  # Messaging 
  acts_as_messageable
  before_destroy { messages.destroy_all }

private
  
  def mailboxer_email(object)
    return self.email
  end
  
  def name
    return self.fname
  end
  
  def strip_blanks
  	self.fname = self.fname.strip
  	self.lname = self.lname.strip
  end

  def subscribe_user_to_mailing_list
    SubscribeUserToMailingListJob.perform_later(self)
  end
 
end
