class UserMailer < ActionMailer::Base
  default from: "friend@aroundyoga.com"
  
  def friend_request(user, friend)
    @user = user
    @friend = friend

    mail(:to => @friend.email, :subject => "Friend Request")
  end
  
  def send_message(message)
    @recipient = message.recipient
    @subject = message.subject
    @body = message.body
    mail(:to => @recipient.email, :subject => @subject)
  end

end
