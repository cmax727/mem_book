class ApplicationController < ActionController::Base
  include BareBoneController
  
  private
    
  def setup_user
    @user = User.find(params[:user_id])
  end
  
  def create_activity(user_id, event, target, target_id)
    Activity.new(user_id: user_id, event: event, target: target, target_id: target_id).save!
  end
    
end
