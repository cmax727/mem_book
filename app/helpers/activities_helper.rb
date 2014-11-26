module ActivitiesHelper
  def display_activity(activity)
    target = activity.target
    case target
    when "Group"
      group = Group.find(activity.target_id)
      output = activity.event.to_s + ' the group ' + "\"#{group.name}\""
      
    when "Comment"
      comment = Comment.find(activity.target_id)
      unless comment.picture_id.nil?
        picture = Picture.find(comment.picture_id)
        output = activity.event.to_s + ' the picture ' + "\"#{picture.title}\""
      else
        discussion = Discussion.find(comment.discussion_id)
        output = activity.event.to_s + ' the discussion ' + "\"#{discussion.title}\""
      end
      
    when "Picture"
      picture = Picture.find(activity.target_id)
      output = activity.event.to_s + ' the picture ' + "\"#{picture.title}\""
    when "Event"
      event = Event.find(activity.target_id)
      output = activity.event.to_s + ' the event ' + "\"#{event.name}\""
    when "Friend"
      friend = User.find(activity.target_id)
      output = activity.event.to_s + ' friend with ' + "\"#{friend.name}\""
    when "UpdateStatus"  
      update_status = UpdateStatus.find(activity.target_id)
      output = update_status.context
    end
    return output
  end
end
