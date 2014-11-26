class DiscussionsController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
  
  def show
    @group = Group.find(params[:group_id])
    @discussion = Discussion.find(params[:id])
    
    @user = @discussion.user
    @comments = @discussion.comments
    @comments_count = @comments.size
    @users = @group.users
    @joined_state = !Membership.find_by_user_id_and_group_id(current_user.id, @group.id).nil?
    
    @owners = @group.owners
    @leaders = @group.leaders
    
    @friends = @user.friends
    
    @editable_state = @owners.include?(current_user) || @leaders.include?(current_user) 
    
  end
  
  def new
    @group = Group.find(params[:group_id])
    @discussion = Discussion.new
    @user = current_user
  end
  
  def create
    @user = current_user
    @group = Group.find(params[:group_id])
    unless params[:discussion][:title].empty?
      discussion = Discussion.new(params[:discussion])
      discussion.user = @user
      discussion.group = @group
      discussion.last_activity_at = Time.now
      discussion.save!
      
      # create activity to start this discussion
      create_activity(current_user.id, "started", "Discussion", discussion.id)
      
      redirect_to latest_discussions_group_path(@group) and return
    
    end
    redirect_to new_group_discussion_path(@group)
  end 
  
  def update    
    discussion = Discussion.find(params[:id])
    discussion.update_attributes(params[:discussion])   
    redirect_to :back
  end 
  
  
end
