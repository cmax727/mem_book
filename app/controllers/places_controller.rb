class PlacesController < ApplicationController
  def index
    @countries = Country.order(:name)
    @user = current_user
    if @user.profile.nil? || @user.profile.place.empty?
      redirect_to :back and return
    end
    @place = @user.profile.place
    
    country = @place.split(",")[2].strip
    @country = Country.find_by_name(country)

    region = @place.split(",")[1].strip
    @region = Region.find_by_name_and_country_pk(region, @country.country_pk)

    city = @place.split(",")[0].strip
    @city = City.find_by_name_and_region_pk_and_country_pk(city, @region.region_pk, @country.country_pk)
    
    @near_regions = @country.regions
  end
  
  def change_regions
    
    if request.xhr?
      puts "this is ajax!!!"
    else
      puts "this is not ajax!!!"
    end
    
    @country = Country.find_by_iso2(params[:code].upcase)
    puts @country.name + " selected!!!"
    @regions = @country.regions
    
    respond_to do |format|
      puts "html is !!!"
      #     format.html      
      format.js do
        puts "js is !!!"
        render "change_regions"
      end
    end     
  end
  
  def show
    
  end

  def people
    
  end
end