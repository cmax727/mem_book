class User < ActiveRecord::Base
  require 'open-uri'
  devise :database_authenticatable,
    :registerable,
    :confirmable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :omniauthable,
    #omniauth_providers: [ :facebook, :google_oauth2 ]
    omniauth_providers: [ :facebook, :twitter, :google_oauth2 ]
  
  # Setup accessible (or protected) attributes for your model  
   attr_accessible :name, :email, :password, :password_confirmation  
  
  has_many  :authorizations, dependent: :destroy
  has_one   :profile, dependent: :destroy
  has_many  :pictures, dependent: :destroy
  has_many  :comments, dependent: :destroy
  has_many  :flags, dependent: :destroy
  has_many  :discussions, dependent: :destroy
  has_many  :memberships, dependent: :destroy
  has_many  :groups, :through => :memberships
  
  has_many  :owner_groups,
            :through => :memberships,
            :source => :group,
            :conditions => "member_type = 'owner'"
            
  has_many  :member_groups,
            :through => :memberships,
            :source => :group,
            :conditions => "member_type = 'member'"

  has_many  :moderator_groups,
            :through => :memberships,
            :source => :group,
            :conditions => "member_type = 'moderator'"
            
  
  has_many  :friendships, dependent: :destroy
 
  has_many  :friends,
            :through => :friendships,
            :conditions => "status = 'accepted'"
            
  has_many  :requested_friends,
            :through => :friendships,
            :source => :friend,
            :conditions => "status = 'requested'"
            
  has_many  :pending_friends,
            :through => :friendships,
            :source => :friend,
            :conditions => "status = 'pending'"
    
  has_many  :messages, dependent: :destroy
            
  has_many  :recipients,
            :through => :messages,
            :uniq => true
            
  has_many  :discussion_followers, dependent: :destroy
            
  has_many  :followed_discussions,
            :through => :discussion_followers,
            :source => :discussion
               
  has_many  :user_events, dependent: :destroy
  has_many  :events, :through => :user_events
  
  has_many  :owner_events,
            :through => :user_events,
            :source => :event,
            :conditions => "related_type = 'owner'"
            
  has_many  :attender_events,
            :through => :user_events,
            :source => :event,
            :conditions => "related_type = 'attender'"

  has_many  :user_interests, dependent: :destroy
  has_many  :interests, :through => :user_interests
  
  has_many  :owner_interests,
            :through => :user_interests,
            :source => :interest,
            :conditions => "related_type = 'owner'"
            
  has_many  :member_interests,
            :through => :user_interests,
            :source => :interest,
            :conditions => "related_type = 'member'"          
  
  has_many  :activities, dependent: :destroy    
  has_many  :update_statuses, dependent: :destroy                     
  # replace has_many          
  def senders
    sender_msgs = Message.where('recipient_id = ?', id).select(:user_id).uniq
    user_ids = []
    sender_msgs.each do |msg|
      user_ids << msg.user_id
    end
    User.find(user_ids)
  end       
  
  def received_messages 
    Message.where('recipient_id = ?', id)
  end  
  
  def find_messages
    Message.where('user_id = ? or recipient_id = ?', id, id)
  end
  
  def messages_with other
    Message.where('user_id = ? and recipient_id = ? or user_id = ? and recipient_id = ?', id, other.id, other.id, id)
  end
  
  def messanger message
    if message.user == self 
      message.recipient
    elsif message.recipient == self
      message.user
    end
  end      

  
  accepts_nested_attributes_for :profile, update_only: true

  validates :name,
    presence: true,
    length:   { maximum: 200, :unless => proc { |x| x.name.to_s.blank? } }
  
  # validates_email_realness_of :email
    
  attr_accessible :avatar
  
  has_attached_file :avatar, :styles => { :medium => "180x180>", :small => "81x81>", :group_thumb => "43x43>", :thumb => "27x27>" }
    
    
  def self.find_for_provider_email(provider_id, uid, oauth_name, oauth_url, oauth_pic_url, oauth_access_token, name, email, password)
    user = User.where( email: email ).lock.first
    if user
      puts "start user"
      ::Rails.logger.info "User with email: #{email.inspect} already exists! Appending authorization!"
      unless user.avatar.exists?
        user.avatar = URI.parse(oauth_pic_url)
        user.save!
      end
      unless Authorization.new( user_id: user.id, provider_id: provider_id, uid: uid, name: oauth_name, url: oauth_url, access_token: oauth_access_token).save
        puts "start authorization new"
        raise ActiveRecord::Rollback
      end
    else
      puts "start user else"
      ::Rails.logger.info "User with email: #{email.inspect} doesn't exist! Creating user and appending authorization!"

      user = User.new(
        name: name,
        email: email,
        password: password,
        avatar: URI.parse(oauth_pic_url)
      )
      # user.registration = true
      user.skip_confirmation!

      unless user.save! && Authorization.new( user_id: user.id, provider_id: provider_id, uid: uid, name: oauth_name, url: oauth_url, access_token: oauth_access_token).save!
        puts "start unless"
        ::Rails.logger.info "User (or authorization) creation failed!"
        user = nil
        raise ActiveRecord::Rollback
      end
    end
    user 
  end

  def self.find_for_provider_auth(provider, auth)
    return unless provider && auth

    user = nil
    uid = auth.uid
    email = auth.info.email.to_s  
    
        
    name = auth.info.name.to_s
    
      
    provider_id = OAuthProviders.symbol_to_id(provider)

    puts "uid: "+uid

    puts "name: " + name
    puts "provider: " + provider.class.to_s
    puts "provider_id: " + provider_id.to_s
    transaction do
      puts "start transaction"
      authorization = Authorization.joins( :user ).where( provider_id: provider_id, uid: uid ).lock.first

      if !authorization
        puts "start authorization"
        ::Rails.logger.info "No authorization found for provider: #{provider.inspect} and uid: #{uid.inspect}"
        user = User.where( email: email ).lock.first

        if user
          puts "start user"
          ::Rails.logger.info "User with email: #{email.inspect} already exists! Appending authorization!"
          if Authorization.new( user_id: user.id, provider_id: provider_id, uid: uid ).save
            puts "start authorization new"
         #   raise ActiveRecord::Rollback
          end
        else
          puts "start user else"
          ::Rails.logger.info "User with email: #{email.inspect} doesn't exist! Creating user and appending authorization!"

          user = User.new(
            name: name,
            email: email,
            password: Devise.friendly_token[0, 20]
          )
          # user.registration = true
          user.skip_confirmation!

          unless user.save! && Authorization.new( user_id: user.id, provider_id: provider_id, uid: uid ).save!
            puts "start unless"
            ::Rails.logger.info "User (or authorization) creation failed!"
            user = nil
            raise ActiveRecord::Rollback
          end
        end
      else
        puts "start authorization else"
        user = authorization.user
      end
    end
    puts "end user"
    user
  end

  def setup_profile!
    transaction do
      begin
        self.lock!
      rescue
        raise ActiveRecord::Rollback
      end

      profile = Profile.includes(city: [:region, :country]).where(user_id: self.id).first

      unless profile
        profile = Profile.new(user_id: self.id)
        raise "Couldn't create user profile!" unless profile.save!
      end
    end
  end

end
