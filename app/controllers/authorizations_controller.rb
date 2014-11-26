class AuthorizationsController < ApplicationController
  
  def destroy
    puts params
    @authorization = Authorization.find(params[:format])
    @authorization.destroy
    # redirect_to :controller => "dashboards", :action => "settings"
    redirect_to :back
  end
end
