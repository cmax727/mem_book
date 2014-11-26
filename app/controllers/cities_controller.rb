class CitiesController < ApplicationController
  # skip_before_filter :setup_profile_if_needed

=begin
  respond_to    :js,    only: :autocomplete
  allow_format! :json,  only: :autocomplete
  
  
  def autocomplete
    term = params[:term].to_s
    tokens = term.split(' ').size

    @cities = City.search do
      fulltext(term) do
        minimum_match(tokens)
      end
      paginate(:page => 1, :per_page => 15)
    end.results

    render json: @cities
  end
  
=end

  def autocomplete
    if request.xhr?
      puts "this is ajax!!!"
    else
      puts "this is not ajax!!!"
    end

    first_char = params[:first_char]
    
    cities = City.where('lower(name) like ?', "%#{first_char.downcase}%")
        
    
    @locations = []
    cities.each do |city|
      @locations << city.google_maps_query
    end
    
    respond_to do |format|      
      format.json  { render :json => @locations }
    end        
  end
  
  def fetch_cities
    
    @country = Country.find(params[:country])
    @region = Region.find(params[:region])
    cities = City.where('country_pk = ? and region_pk = ?', @country.country_pk, @region.region_pk)
    
    @cities = []
    
    cities.each do |city|
      @cities << [city.city_pk, city.name]
    end
    
    respond_to do |format|      
      format.json  { render :json => @cities }
    end   
        
  end
  
  def show
    
    @render_type = 'city'
    @city = City.find(params[:id])
    @region = Region.find(params[:region_id])
    @country = Country.find(params[:country_id])
    
    @peoples = []
    profiles = Profile.where('lower(place) like ?', "%#{@city.name.downcase}%")
    profiles.each do |profile|
      @peoples << profile.user
    end
    
    @groups = []
    groups = Group.where('lower(name) like ?', "%#{@city.name.downcase}%")
    groups.each do |group|
      @groups << group
    end
    
    @groups.each do |g|
      puts g.name
    end
   
    @events_near_city = Event.where('lower(place) like ?', "%#{@city.name.downcase}%").order('created_at DESC')
    
    @near_cities = @region.cities.where('city_pk <> ?', @city.city_pk)
 
    cities_users = []
    @near_cities.each do |city|
      cities_users << {:city => city, :users => Profile.where('place like ?', "%#{city.name}%").size}
    end
    
    sorted_arr = cities_users.sort_by{|e| -e[:users]}
    @near_cities = []
    sorted_arr.each do |element|
      @near_cities << element[:city]
    end    
    
    puts cities_users
    render 'places/show'

  end
  

end