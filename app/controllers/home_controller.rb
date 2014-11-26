class HomeController < ApplicationController
  include VerifyNotLoggedIn

  layout "land", :only => [:index, :register, :create_user]

  def index
    # create a blank user
    # @user = User.new
  end
  
  def manual
    @user = User.new
    
    @countries = Country.order(:name)
    @countries.unshift(Country.new)
    
    @regions = []
    @cities = []
    
    render :layout => 'page'
  end  

  def register
    q = params[:user].as_hash

    q.reject! { |k, v| !["name", "email", "password"].include?(k) }
    
    if params[:user][:name].empty?
      flash[:name_error] = "User name can't be blank"
      redirect_to :back and return
    end

    if params[:user][:email].empty?
      flash[:email_error] = "User email can't be blank"
      redirect_to :back and return
    end
    
    unless EmailVerifier.check(params[:user][:email])
      flash[:email_error] = "Email address doesn't exist"
      redirect_to :back and return
    end
   
    if params[:user][:password].empty?
      flash[:password_error] = "User password can't be blank"
      redirect_to :back and return
    end
            
    if params[:country].empty?
      flash[:country_error] = "Country can't be blank" 
      redirect_to :back and return
    end

    @user = User.new(q)
  
    if @user.save
      @user.profile = Profile.new
      @profile = @user.profile
      place = Country.find(params[:country]).name
      unless params[:region].nil?
        place = Region.find(params[:region]).name + ' ,' + place        
      end
      
      unless params[:city].nil?
        place = City.find(params[:city]).name + ' ,' + place        
      end
      
      @profile.place = place
      @profile.save! 
      flash[:notice] = "Please confirm your email ID by clicking the verification email. Kindly check your spam folder"
    else
      flash[:error] = "Your registration couldn't be complete. Please review your details."
    end
    
    @user.password = @user.password_confirmation = nil
    redirect_to :back
  end
  
  def create_user
    
=begin
    ## form validation
    if params[:user][:name].empty?
      flash[:name_error] = "User name can't be blank"
      redirect_to :back and return
    end

    if params[:user][:email].empty?
      flash[:email_error] = "User email can't be blank"
      redirect_to :back and return
    end
    
    unless EmailVerifier.check(params[:user][:email])
      flash[:email_error] = "Email address doesn't exist"
      redirect_to :back and return
    end
   
    if params[:user][:password].empty?
      flash[:password_error] = "User password can't be blank"
      redirect_to :back and return
    end
            
    if params[:country].empty?
      flash[:country_error] = "Country can't be blank" 
      redirect_to :back and return
    end
    ## end
=end

    
    user = params[:user]
 
    @user = User.find_for_provider_email(params[:provider_id], params[:uid], params[:name], params[:url], params[:pic_url], params[:access_token], user[:name], user[:email], user[:password])
    
     
    
    if @user && @user.persisted?
      notice(I18n.t "devise.omniauth_callbacks.success", kind: OAuthProviders.id_to_symbol(params[:provider_id]).to_s)
      
      @user.profile = Profile.new
      @profile = @user.profile
      place = Country.find(params[:country]).name
      unless params[:region].nil?
        place = Region.find(params[:region]).name + ' ,' + place        
      end
      
      unless params[:city].nil?
        place = City.find(params[:city]).name + ' ,' + place        
      end
      
      @profile.place = place
      @profile.save! 
            
      sign_in_and_redirect @user, :event => :authentication
    else
      warning(error ? error.to_s : "error!!!")
      # redirect_to :root, :notice => (error ? error.to_s : "")
      redirect_to root_url
    end

  end

end