#current class DashboardsController < SecureController
class DashboardsController < ApplicationController
 before_filter :authenticate_user!  

  ## Application
  def show
    @user = current_user
    
    @friends = @user.friends
    @my_activities = @user.activities.order('created_at DESC')
    
    @friend_activities = []
    
    @friends.each do |friend|
      @friend_activities = @friend_activities + friend.activities
    end    
    
    @activities = @my_activities + @friend_activities
    
    #update status
    @update_status = UpdateStatus.new
  end 
  
  def group_feed
    @user = current_user
    
    @friends = @user.friends
    @my_activities = @user.activities.where(:target => ["Group", "Comment"]).order('created_at DESC')
    
    @friend_activities = []
    
    @friends.each do |friend|
      @friend_activities = @friend_activities + friend.activities.where(:target => ["Group", "Comment"]).order('created_at DESC')
    end    
    
    activities = @my_activities + @friend_activities
    
    # remove picture comment activity
    @activities = activities
    activities.each do |act|
      if act.target == "Comment"
        if Comment.find(act.target_id).discussion_id.nil?
          @activities = @activities - [act]
        end
      end
    end
    
    #update status
    @update_status = UpdateStatus.new
    
    render :show
    
  end

  def places
    
  end

  def reset_password
  end

  def interests
  end

  def upload_picture
  end
  
  def search
    query = params[:search_query]
    if query.empty?
      redirect_to :back and return
    else
      @peoples = User.where('lower(name) like ?', "%#{query.downcase}%").order('current_sign_in_at DESC')
      
      @events = Event.where('lower(name) like ?', "%#{query.downcase}%").order(:name)
      @groups = Group.where('lower(name) like ?', "%#{query.downcase}%").order(:name)
      @countries = Country.where('lower(name) like ?', "%#{query.downcase}%")
      @regions = Region.where('lower(name) like ?', "%#{query.downcase}%")
      @cities = City.where('lower(name) like ?', "%#{query.downcase}%")
    end
 
  end


  def settings
    @user = current_user
    auth = request.env["omniauth.auth"]
    puts auth
    @facebook = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 1000).first
    @twitter  = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 2000).first
    @google   = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 3000).first
  end
  
  def update_settings
    puts "okokokokokokokokokokokokokokokokokokokokokokokokokokoko"
    email = params[:email]
    if email.empty?
      puts "email is empty!!!!!!!!!!!!!!!!!!"
      redirect_to :back and return
    end
    user = current_user
    user.email = email
    puts "email changed? " + user.changed?.to_s
    puts "email changed" if user.email_changed?
    puts "email: " + email.to_s
    
    begin
      if !user.email.empty? && user.email_changed?
        user.send_confirmation_instructions  
      end
      
    rescue => e
      error = e
      puts error
    ensure
      #
    end    
    redirect_to :back    
  end
  
  def connect_facebook
    puts "start facebook"
    begin
      auth = request.env["omniauth.auth"]
      puts auth
      @provider_id = OAuthProviders.symbol_to_id(provider)
      @uid = auth.uid
      
      authorization = Authorization.joins( :user ).where( provider_id: @provider_id, uid: @uid ).lock.first
      @user = User.new
      if !authorization        
        @user.name = auth.info.name.to_s        
        @user.email = auth.info.email.to_s unless provider.to_s == "twitter"
        render :action => "confirm" and return
      else
        @user = authorization.user
      end      
    rescue => e
      error = e
      puts error
    ensure
      #
    end

  end

  def resend_unlock
  end

  def resend_instructions
  end

  def people
    @user = current_user
    @friends = @user.friends
  end

  def pictures
  end

  def picture
  end

end