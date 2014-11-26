class MessagesController < ApplicationController
 before_filter :authenticate_user!   
 
 
  def create    
    unless params[:message][:body].empty?
      # send message in the profile view page
      
      case params[:message_type]
      when 'profile_message', 'reply_message'  
        @recipient = User.find(params[:user_id])  
        @user = current_user        
      when 'new_message'
        recipient_name = params[:message][:recipient]
        @recipient = User.find_by_name(recipient_name)
        @user = User.find(params[:user_id])         
      else
        redirect_to :back and return        
      end
    
      @message = Message.new  
      @message.body = params[:message][:body]      
      @message.user = @user
      @message.recipient = @recipient          
      @message.save!
    end    
    redirect_to :back
=begin
    if @message.save      
      UserMailer.send_message(@message).deliver
    end
=end
  end 
  
  def inbox
    @user = current_user
    @senders = current_user.senders
    @recipients = current_user.recipients
    @messaged_users = Message.users_messaged_with current_user
    @messages = current_user.find_messages
    @message = Message.new
  end
  
  def messages_with_user
    @user = User.find(params[:user_id])      
    @messages = @user.find_messages
    @messages.each do |msg|
    unless msg.read?
      msg.read_at = Time.now
      msg.save!  
    end      
    end
    @message = Message.new    
  end
  
end
