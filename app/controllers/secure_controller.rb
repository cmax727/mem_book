class SecureController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_profile_if_needed
  before_filter :check_profile

private

  def authenticate_user!
    session["user_return_to"] = request.fullpath
    # raise session["user_return_to"]
    super
  end

  def setup_profile_if_needed
    current_user.setup_profile!
  end

  def check_profile
    unless current_user.profile.complete?
      redirect_to edit_strange_url
    end
  end

end