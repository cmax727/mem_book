module FriendshipHelper
  # Return an appropriate friendship status message.
  def friendship_status(user, friend)
    friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
    return "Add Friend" if friendship.nil?
    case friendship.status
      when 'requested'
        "Friend request sent"
      when 'accepted'
        "Friend"
    end
  end

end
