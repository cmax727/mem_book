class UpdateStatusesController < ApplicationController
   def create
    puts 'create'
    ## create and save an update status of the user
    @user = User.find(params[:user_id])
    @user.update_statuses << UpdateStatus.new(params[:update_status])
    ## end
    
    # create activity to start this discussion
    create_activity(current_user.id, "did", "UpdateStatus", @user.update_statuses.last.id)
    
    redirect_to :back 
  end
end
