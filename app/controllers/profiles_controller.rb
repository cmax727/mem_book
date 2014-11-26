class ProfilesController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :setup_user
  before_filter :check_access, :only => [:edit, :update]
  
  include FriendshipHelper

     
  def show
    
    if request.xhr?
      puts "this is ajax!!!"
    else
      puts "this is not ajax!!!"
    end
        
    @friend_status = friendship_status(@user, current_user)
    
    @user.profile ||= Profile.new
    @profile = @user.profile
    @goals = nil
    if @profile.goal.nil?
      @goals = nil
    else
      @goals = @profile.goal.split(',')  
    end
    @recipient = @user
    @message = Message.new
    @friends = @user.friends
    
    @me = current_user
    @mutual_friends = []
    @friends.each do |friend|
      if @me.friends.include?(friend)
        @mutual_friends << friend
      end
    end
    
    @owner_groups = @user.owner_groups
    @moderator_groups = @user.moderator_groups
    @member_groups = @user.member_groups
    
    @interests = @user.interests
    
    @interests_arr = []
   
    @interests.each do |interest|
      @interests_arr << interest.name
    end
    
    @events = @user.events
    
    ## activities
    @activities = @user.activities.order('created_at DESC')    
  end

  def edit
    @title = "Edit Profile"
    @user.profile ||= Profile.new
    @profile = @user.profile
    @goals = nil
    if @profile.goal.nil?
      @goals = nil
    else
      @goals = @profile.goal.split(',')  
    end
    
    unless @profile.place.nil?

      @country = Country.find_by_name(@profile.place.split(",")[2].strip)
      @region = Region.find_by_name_and_country_pk(@profile.place.split(",")[1].strip, @country.country_pk)    
      @city =    City.find_by_name_and_country_pk_and_region_pk(@profile.place.split(",")[0].strip, @country.country_pk, 
                                                                                                    @region.region_pk)
      
      @countries = Country.order(:name)
      @regions = Region.where('country_pk = ?', @country.country_pk)
      @cities  = City.where('country_pk = ? and region_pk = ?', @country.country_pk, @region.region_pk)
      
     

    else
      
      @country = nil
      @region = nil
      @city = nil
      
      @countries = Country.order(:name)
      @regions = nil
      @cities = nil

    end
    
        
    @interests = @user.interests
    
    @interests_arr = []
   
    @interests.each do |interest|
      @interests_arr << interest.name
    end

  end

  def update    
    
    if params[:update_type] == "aboutMe"
      ## when click about me edit link in the view profile page      
      @user.profile.update_attributes(params[:profile])
      redirect_to :action => "show"
    else
      ## when click save button in the edit profile page
    
       profile = params[:profile]
       goal_ids = profile[:goal_ids]
       !params[:country].nil? ? country = Country.find(params[:country].to_i).name : country = ""
       !params[:region].nil? ? region = Region.find(params[:region].to_i).name : region = ""
       !params[:city].nil? ? city = City.find(params[:city].to_i).name : city = ""
       
       
       
       @user.profile.goal = nil
       
       unless goal_ids.nil?
         goals = Goal.find(goal_ids)
         profile_goal = goals.first.id.to_s
         
         goals.each do |goal|
           unless goal.id.to_s == profile_goal
             profile_goal = profile_goal + ',' + goal.id.to_s
           end
         end  
         @user.profile.goal = profile_goal  
       end
           
       if @user.update_attributes(profile[:user]) && @user.profile.update_attributes(profile.except(:user, :goal_ids)) 
         place = city + ', ' + region + ', ' + country
         @user.profile.update_attributes(:place => place) 
         flash[:notice] = "Changes saved."
         redirect_to :action => "show"
       end  
    end
 
  end

  
  private    
  
  def check_access
    setup_user
    # @user = User.find(params[:user_id])
    redirect_to :action => :show and return unless @user == current_user
  end
    
  
end


