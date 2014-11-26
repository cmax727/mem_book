class CommentsController < ApplicationController
  def create
    if params[:comment][:body].empty?
      redirect_to :back and return
    else
      @editable_state = false
      case params[:comment_type]
      when 'discussion'
        @user = current_user
        @discussion = Discussion.find(params[:discussion_id])
        @group = Group.find(params[:group_id])
        @owners = @group.owners
        @leaders = @group.leaders        
        @editable_state = @owners.include?(@user) || @leaders.include?(@user)        
        
        comment = Comment.new(params[:comment])
        comment.user_id = current_user.id
        @discussion.comments << comment
        @comment = @discussion.comments.last   
        @discussion.last_activity_at = @comment.created_at  
        @discussion.save!
        @comment = @discussion.comments.last

       
        puts "This is discussion"
        puts @editable_state
      when 'picture'
        @picture = Picture.find(params[:picture_id])
        comment = Comment.new(params[:comment])
        comment.user_id = current_user.id
        @picture.comments << comment
        @comment = @picture.comments.last
        
        puts "This is picture"
        puts @editable_state
      end
      
      # create activity to post a comment to this discussion or picture
      create_activity(current_user.id, "posted", "Comment", @comment.id)
      
    end
    respond_to do |format|
      #     format.html      
      format.js do
        render "comments/add_comment"
      end
    end    

  end
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to :back
  end
  
  def like
    if Comment.where(:user_id => current_user.id, :picture_id => params[:picture_id], :like => true).empty?
      picture = Picture.find(params[:picture_id])
      comment = Comment.new(:user_id => current_user.id, :like => true)
      picture.comments << comment
      comment = picture.comments.last
      
      
      
      respond_to do |format|
        redirect_to :back and return
        #     format.html      
        format.js do
          #     format.js      
        end
      end
    end     
  end
  
  def flag
    puts "flaged!!!!!!!!"
    if params[:innapropriate] || params[:off_topic] || params[:offensive]
      puts 'checked!!!!'
      group = Group.find(params[:group_id])
      comment = Comment.find(params[:comment_id])
      if comment.flags.size < group.setting.flag_count - 1
        flag = Flag.new
        flag.user_id = current_user.id
        flag.comment_id = params[:comment_id]
        flag.innapropriate = params[:innapropriate]
        flag.off_topic     = params[:off_topic]
        flag.offensive = params[:offensive] 
        
        flag.save!      
        puts 'saved!!!!'
      else
        comment.destroy        
      end
    end  
    redirect_to :back
  end
end
