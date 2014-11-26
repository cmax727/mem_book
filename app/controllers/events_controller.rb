class EventsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :near_events_parameters_setup, :only => [:near_city, :near_region, :near_country]
  
  def all
    @events = Event.order('created_at DESC')
  end
  
  def my
    @user = current_user
    @owner_events = @user.owner_events
    @attender_events = @user.attender_events
    
  end
  
  def show
    @event = Event.find(params[:id])
    @user = current_user
    @owner = @event.owners.first
    
    @attend_state = true unless @event.users.include?(@user)
    
    @facebook = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 1000).first
    @twitter  = Authorization.where('user_id = ? and provider_id = ?',current_user.id, 2000).first
    

  end

  def search
    
    query = params[:search_query]
    if @event = Event.where('lower(name) = ?', query.downcase).first
      @user = current_user
      @owner = @event.owners.first
      
      @attend_state = true unless @event.users.include?(@user)
      render :show and return
    else
      redirect_to :back
    end
     
  end
    
  def new
    @event = Event.new
    @user = current_user
    @profile = @user.profile
    
    @country = Country.find_by_name(@profile.place.split(",")[2].strip)
    @region = Region.find_by_name_and_country_pk(@profile.place.split(",")[1].strip, @country.country_pk)    
    @city =    City.find_by_name_and_country_pk_and_region_pk(@profile.place.split(",")[0].strip, @country.country_pk, 
                                                                                                  @region.region_pk)
        
    @countries = Country.order(:name)
    @regions = Region.where('country_pk = ?', @country.country_pk)
    @cities  = City.where('country_pk = ? and region_pk = ?', @country.country_pk, @region.region_pk)
  end
  
  def create

    @user = current_user
    
    !params[:country].nil? ? country = Country.find(params[:country].to_i).name : country = ""
    !params[:region].nil? ? region = Region.find(params[:region].to_i).name : region = ""
    !params[:city].nil? ? city = City.find(params[:city].to_i).name : city = ""
    
    unless params[:event][:name].empty?
      @event = Event.new(params[:event])
      place = city + ', ' + region + ', ' + country
      @event.place = place
      @event.save!
      
      # create activity to create this event
      create_activity(current_user.id, "created", "Event", @event.id)
      
      user_event = UserEvent.new
      user_event.user = @user
      user_event.event = @event
      user_event.related_type = 'owner'
      user_event.save!
      
      redirect_to :action => :all and return
    
    end
    redirect_to :back 
  end
  
  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to :back
  end
  
  def near_city
        
    # @events_near_city = Event.where('lower(name) like ?', "%#{@city.downcase}%").order('created_at DESC')
    @events_near_city = Event.where('lower(place) like ?', "%#{@city.downcase}%").order('created_at DESC')
    
    @render_type = "near_city"
    render 'near_me'
    
  end
  
  def near_region
        
    # @events_near_region = Event.where('lower(name) like ?', "%#{@region.downcase}%").order('created_at DESC')
    @events_near_region = Event.where('lower(place) like ?', "%#{@region.downcase}%").order('created_at DESC')
    
    @render_type = "near_region"  
    render 'near_me'  
    
  end
  
  def near_country
    
    # @events_near_country = Event.where('lower(name) like ?', "%#{@country.downcase}%").order('created_at DESC')
    @events_near_country = Event.where('lower(place) like ?', "%#{@country.downcase}%").order('created_at DESC')
    
    @render_type = "near_country"  
    render 'near_me'
        
  end
  
  def attend
    
    user = current_user
    event = Event.find(params[:id])
    unless UserEvent.find_by_user_id_and_event_id(user.id, event.id)
      user_events = UserEvent.new
      user_events.user = user
      user_events.event = event
      user_events.related_type = 'attender'
      user_events.save!   
    end
        
    redirect_to :back
    
  end
  
  def not_attend
    
    user = current_user
    event = Event.find(params[:id])
    user_event = UserEvent.find_by_user_id_and_event_id(user.id, event.id)
    
    user_event.destroy if user_event  
    
    redirect_to :back
    
  end  
  
  def autocomplete

    first_char = params[:first_char]
    
    events = Event.where('lower(name) like ?', "%#{first_char.downcase}%")
        
    
    @events_name = []
    events.each do |event|
      @events_name << event.name
    end
    
    respond_to do |format|      
      format.json  { render :json => @events_name }
    end      
  end
  
  def share_facebook
    @event = Event.find(params[:id])
    access_token = current_user.authorizations.first.access_token
    puts access_token

    me = FbGraph::User.me(access_token)
    puts event_url(@event)
    me.feed!(
      :message => 'Updating via AroundYoga',
      # :picture => asset_path("around_yoga_icon320.png"),
      :link => event_url(@event),
      :name => @event.name,
      :description => @event.description
    )

=begin
    @graph = Koala::Facebook::API.new(access_token)
    puts @graph
    
    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
    puts profile
    puts "wall start"
    @graph.put_wall_post("hi, dude")
    # @graph.put_connections("me", "feed", :message => "I am writing on my wall!")
    puts "wall end"
=end    
    redirect_to :back
  end
  
  private
  
  def near_events_parameters_setup
    @user = current_user
    @place = @user.profile.place
    @city = @place.split(",")[0].strip
    @region = @place.split(",")[1].strip
    @country = @place.split(",")[2].strip
  end

end