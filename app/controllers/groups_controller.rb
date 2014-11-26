# class GroupsController < SecureController
class GroupsController < ApplicationController
  include GroupsHelper
  before_filter :authenticate_user! 
  before_filter :discussion_parameters_setup, :only => [:latest_discussions, :latest_activities] 
  before_filter :members_parameters_setup,    :only => [:users, :council, :about, :settings]
  
  def latest_discussions

    @latest_discussions = @discussions.order('created_at DESC')    
    @render_type = 'latest_discussions'
    @discussion = Discussion.new
    render 'discussion_layout'
  end
  
  def latest_activities

    @latest_activities = @discussions.order('last_activity_at DESC')   
    @render_type = 'latest_activities'
    @discussion = Discussion.new
    render 'discussion_layout'
  end
  
  
  def new
    @group = Group.new
  end

  def create
    puts "created ok!!!!!!!!!!!!!!!!"
    @user = current_user
    unless params[:group][:name].empty?
      unless Group.find_by_name(params[:group][:name])
        @group = Group.new(params[:group])
        @group.save!
        
        # create activity to start a group
        create_activity(current_user.id, "started", "Group", @group.id)
        
        membership = Membership.new
        membership.user = @user
        membership.group = @group
        membership.member_type = 'owner'
        membership.save!
        
        @group.setting = Setting.new(:auto_removed => true, :flag_count => 5)
        
        redirect_to :action => :popular and return
      end
    end
    redirect_to :back 
  end
  
  def mine
    @user = current_user
    @groups = @user.groups
    @owner_groups = @user.owner_groups
    @moderator_groups = @user.moderator_groups
    @member_groups = @user.member_groups
    
    @render_type = 'mine'
    
    render 'groups_layout'
  end
  
  def popular
    @render_type = 'popular'
    @popular_groups = popular_groups(Group.all) 
       
    render 'groups_layout'
  end
  
  def recent
    @render_type = 'recent'
    @recent_groups = Group.order('created_at DESC')
    render 'groups_layout'
  end
  
  # users = members
  def users
    
    @render_type = 'members'
    render 'users_layout'
  end
  
  def council
    @leaders = @group.leaders
    
    @render_type = 'council'
    render 'users_layout'
  end
  
  def about
    @render_type = 'about'
    render 'users_layout'   
  end
  
  def settings
    
    @group.setting ||= Setting.new
    @setting = @group.setting
    
    @render_type = 'settings'
    render 'users_layout'   
    
  end
  
  def search
    
    query = params[:search_query]
    if @group = Group.where('lower(name) = ?', query.downcase).first
      @user = current_user    
      @joined_state = !Membership.find_by_user_id_and_group_id(@user.id, @group.id).nil?
      @users = @group.users
      @owners = @group.owners   
      @leaders = @group.leaders
      @discussions = @group.discussions
      @latest_discussions = @discussions.order('created_at DESC')    
      @render_type = 'latest_discussions'
      @discussion = Discussion.new
      render 'discussion_layout' and return
    else
      redirect_to :back 
    end
  end  
  
  def autocomplete

    first_char = params[:first_char]
    
    groups = Group.where('lower(name) like ?', "%#{first_char.downcase}%")
        
    
    @groups_name = []
    groups.each do |group|
      @groups_name << group.name
    end
    
    respond_to do |format|      
      format.json  { render :json => @groups_name }
    end      
  end
  
  def share_facebook
    @group = Group.find(params[:id])
    access_token = current_user.authorizations.first.access_token
    me = FbGraph::User.me(access_token)
    puts latest_discussions_group_url(@group)
    me.feed!(
      :message => 'Updating via AroundYoga',
      # :picture => asset_path("around_yoga_icon320.png"),
      :link => latest_discussions_group_url(@group),
      :name => @group.name,
      :description => @group.description
    )
    redirect_to :back
  end  
  
  private
  
  def discussion_parameters_setup
    @group = Group.find(params[:id])
    @discussions = @group.discussions
    @user = current_user
    @joined_state = !Membership.find_by_user_id_and_group_id(@user.id, @group.id).nil?
    @users = @group.users
    @owners = @group.owners   
    @leaders = @group.leaders
  
    @facebook = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 1000).first
    @twitter  = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 2000).first
  end 
  
  def members_parameters_setup
    @group = Group.find(params[:id])
    @user = current_user
    @joined_state = !Membership.find_by_user_id_and_group_id(@user.id, @group.id).nil?
    @users = @group.users    
    @members = @group.members
    
    @owners = @group.owners
    @editable_state = @owners.include?(@user)    
  end 
  

end