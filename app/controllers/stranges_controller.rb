class StrangesController < SecureController
  skip_before_filter :check_profile
  before_filter :redirect_if_needed

  VALID_ATTRIBUTES = [
    "name",
    "profile_attributes",
  ]

  VALID_ATTRIBUTES_2 = [
    "agrees",
    "city_id"
  ]

  def edit
    # current_user.build_profile unless current_user.profile
    city = current_user.profile.city
    @city_name = city ? city.full_name : ""
  end

  def update
    q = params[:user].as_hash.to_hash
    q.reject! { |k, v| !VALID_ATTRIBUTES.include?(k) }

    q["profile_attributes"] = {} unless q["profile_attributes"].is_a?(Hash)
    q["profile_attributes"].reject! { |k, v| !VALID_ATTRIBUTES_2.include?(k) }
    @city_name = q["profile_attributes"]["city"]

    current_user.attributes = q
    unless current_user.save
      warning "Please review your information", true
      render :edit
    else
      notice "Your basic information were updated succesfully!"
      redirect_to dashboard_url
    end
  end

private

  def redirect_if_needed
    if current_user.profile.complete?
      redirect_to dashboard_url
    end
  end

end