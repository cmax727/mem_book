class Message < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"
  

  # Based on if a message has been read by it's recepient returns true or false.
  def read?
    self.read_at.nil? ? false : true
  end  

  def received_message? user
    self.recipient == user ? true : false    
  end
  
  def self.user_pair_messaged_with user
    where('user_id = ? or recipient_id = ?', user.id, user.id).select([:user_id, :recipient_id]).uniq
  end 
  
  # return users
  def self.users_messaged_with user
    recipients = where('user_id = ? or recipient_id = ?', user.id, user.id).select([:recipient_id]).uniq.where('recipient_id <> ?', user.id)
    users = where('user_id = ? or recipient_id = ?', user.id, user.id).select([:user_id]).uniq.where('user_id <> ?', user.id)
    recipients_a = []
    recipients.each do |r|
      recipients_a << r.recipient_id
    end
    users_a = []
    users.each do |u|
      users_a << u.user_id
    end    
    user_ids = (recipients_a + users_a).uniq  
    
    User.find(user_ids)
      
  end
    
end
