class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :books
  field :shares, :type => Integer, :default => 0

  def self.find_by_email(in_email)
    User.first(conditions: {email: in_email})
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    #Rails::logger.info "FB data: #{data.inspect}"
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      #User.create!(:email => data["email"], :password => Devise.friendly_token[0,20]) 
      fb_id = data.delete("id")
      #Rails::logger.info "fb_id: #{fb_id}"
      User.create!(data.merge(:password => Devise.friendly_token[0,20], :facebook_id => fb_id))
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end
end
