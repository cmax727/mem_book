class FriendshipController < ApplicationController
  
  # include ProfilesHelper
  before_filter :setup_friends

  # Send a friend request.
  # We'd rather call this "request", but that's not allowed by Rails.
  def create

    Friendship.request(@user, @friend)
    UserMailer.friend_request(@user, @friend).deliver
    flash[:notice] = "Friend request sent."
    redirect_to user_profile_path(@friend)
  end
  
  def accept
    
    @user = User.find(params[:user_id])
    @friend = User.find(params[:format])
    
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      
      # create activity to become friend with this person
      create_activity(@friend.id, "became", "Friend", @user.id)
      
      flash[:notice] = "Friendship with #{@friend.name} accepted!"
    else
      flash[:notice] = "No friendship request from #{@friend.name}."
    end
    redirect_to user_friend_requests_path(@user)
    
  end
  
  def ignore
    
    @user = User.find(params[:user_id])
    @friend = User.find(params[:format])
    
    if @user.requested_friends.include?(@friend)
      Friendship.ignore(@friend, @user)
      
    else
      flash[:notice] = "No friendship request from #{@friend.name}."
    end
    redirect_to user_friend_requests_path(@user)
    
  end  
  
  def decline
    
    @user = User.find(params[:user_id])
    @friend = User.find(params[:format])
    
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.name} declined"
    else
      flash[:notice] = "No friendship request from #{@friend.name}."
    end
    redirect_to user_friend_requests_path(@user)
    
  end
  
  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship with #{@friend.screen_name}"
    end
    redirect_to user_profile_path(@friend)
  end
  
  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} deleted!"
    else
      flash[:notice] = "You aren't friends with #{@friend.screen_name}"
    end
    redirect_to hub_url
  end

  
  def friend_requests
    puts "frent_requests start!"
    @user = @friend  
    @ignored_friendships = Friendship.all(:conditions => ['friend_id = ? and status = ?', @user.id, 'ignoring' ], :order => 'created_at ASC')    
    @requested_and_unignored_friendships = Friendship.all(:conditions => ['friend_id = ? and status = ?', @user.id, 'pending' ], :order => 'created_at ASC')
    @requested_and_unignored_friendships.each do |f|
      puts f.user_id
    end
  end
    

  private

  def setup_friends

    @user = current_user
    @friend = User.find(params[:user_id])
  end

end
