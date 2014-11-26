class Users::OAuthCallbacksController < Devise::OmniauthCallbacksController
  layout "page"
  PROVIDER_NAMES = {
    :facebook => "Facebook",
    :google_oauth2 => "Google",
    :twitter => "Twitter"
  }

  def facebook 
    puts "entered facebook"   
    authorize(:facebook)
  end

  def twitter
    puts "entered twitter !!!"
    authorize(:twitter)
  end

  def google_oauth2
    authorize(:google_oauth2)
  end
  
  def confirm    

  end
  
private

  def authorize( provider )
    puts "start facebook authentication"
    error = nil
    begin
      puts request.env["omniauth.auth"]
      auth = request.env["omniauth.auth"]
      puts "auth start: "
      puts auth
      puts "auth end: "
      @provider_id = OAuthProviders.symbol_to_id(provider)
      @uid = auth.uid
      @name = auth.info.name.to_s
      @pic_url = nil
      @url = nil
      ## get access token from facebook
      @access_token = auth.credentials.token
      if provider.to_s == "facebook"
        @url = auth.info.urls.Facebook.to_s
        @pic_url = auth.info.image.to_s
      elsif provider.to_s == "twitter"
        puts "twitter step 2"
        @url = auth.info.urls.Twitter.to_s
        @pic_url = auth.info.image.to_s
        puts "twitter step 3"
      elsif provider.to_s == "google_oauth2"
        @url = auth.extra.raw_info.link.to_s
      end
      
      
=begin
      @url = auth.info.urls.Facebook.to_s   if provider.to_s == "facebook"
      @url = auth.info.urls.Twitter.to_s    if provider.to_s == "twitter"
      @url = auth.extra.raw_info.link.to_s  if provider.to_s == "google_oauth2"
=end

      
      authorization = Authorization.joins( :user ).where( provider_id: @provider_id, uid: @uid ).lock.first
      @user = User.new
      if !authorization   
        if current_user
          puts "current User is in here!!!!!"
          @user = current_user
          
          unless Authorization.new( user_id: @user.id, provider_id: @provider_id, uid: @uid, name: @name, url: @url, access_token: @access_token ).save!
            ::Rails.logger.info "Authorization creation failed!"
            authorization = nil
            raise ActiveRecord::Rollback
          end
          puts "start settings redirect: "
          redirect_to settings_path and return
          puts "end settings redirect: "         
        else     
          @user.name = auth.info.name       
          @user.email = auth.info.email.to_s unless provider.to_s == "twitter"
               
          @countries = Country.order(:name)
          @countries.unshift(Country.new)
          
          @regions = []
          @cities = []
          
          render :action => "confirm" and return
        end
      else
        @user = authorization.user
      end      
    rescue => e
      error = e
    ensure
      #
    end

    if ::Rails.env.development? && e
       raise e
     end
 
     if @user && @user.persisted?
       puts "xxxyyyzzz"
       notice(I18n.t "devise.omniauth_callbacks.success", kind: PROVIDER_NAMES[provider])
       sign_in_and_redirect @user, :event => :authentication
     else
       puts "xxxyyyzzz123123213213"
       warning(error ? error.to_s : "error!!!")
       # redirect_to :root, :notice => (error ? error.to_s : "")
       redirect_to root_url
     end
  end
end