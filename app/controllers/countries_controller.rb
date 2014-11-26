# class CountriesController < SecureController
class CountriesController < ApplicationController
  def show
    @render_type = 'country' 
    if params[:id].to_i == 0
      @country = Country.find_by_name(params[:id])
    else
      @country = Country.find(params[:id])  
    end   
    
    
    @peoples = []
    profiles = Profile.where('lower(place) like ?', "%#{@country.name.downcase}%")
    profiles.each do |profile|
      @peoples << profile.user
    end
    
    @groups = []
    groups = Group.where('lower(name) like ?', "%#{@country.name.downcase}%")
    groups.each do |group|
      @groups << group
    end
    
    @events_near_country = Event.where('lower(place) like ?', "%#{@country.name.downcase}%").order('created_at DESC')
    
    @near_regions = @country.regions.where('name <> ?', @country.name)
    
    regions_users = []
    @near_regions.each do |region|
      regions_users << {:region => region, :users => Profile.where('place like ?', "%#{region.name}%").size}
    end
    
    sorted_arr = regions_users.sort_by{|e| -e[:users]}
    @near_regions = []
    sorted_arr.each do |element|
      @near_regions << element[:region]
    end       
        
    render 'places/show'
  end


end
