class RegionsController < ApplicationController


  def show
    @render_type = 'region'
    @region = Region.find(params[:id])
    @country = Country.find(params[:country_id])  

    @peoples = []
    profiles = Profile.where('lower(place) like ?', "%#{@region.name.downcase}%")
    profiles.each do |profile|
      @peoples << profile.user
    end
    
    @groups = []
    groups = Group.where('lower(name) like ?', "%#{@region.name.downcase}%")
    groups.each do |group|
      @groups << group
    end
    
    @events_near_region = Event.where('lower(place) like ?', "%#{@region.name.downcase}%").order('created_at DESC')
     
    @near_cities = @region.cities
    
    cities_users = []
    @near_cities.each do |city|
      cities_users << {:city => city, :users => Profile.where('place like ?', "%#{city.name}%").size}
    end
    
    sorted_arr = cities_users.sort_by{|e| -e[:users]}
    @near_cities = []
    sorted_arr.each do |element|
      @near_cities << element[:city]
    end    
          
      
    render 'places/show'
  end
  
  def fetch_regions
    if request.xhr?
      puts "this is ajax!!!"
    else
      puts "this is not ajax!!!"
    end
    
    puts "started fetch"
    
    @country = Country.find(params[:country])
    regions = Region.where('country_pk = ?', @country.country_pk)
    
    @regions = []
    
    regions.each do |region|
      @regions << [region.region_pk, region.name]
    end
    
    respond_to do |format|      
      format.json  { render :json => @regions }
    end   
    
  end


end
