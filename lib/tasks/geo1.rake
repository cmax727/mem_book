require "csv"

namespace :geo do

  namespace :countries do

    task load: :environment do
      puts 'Loading countries ...'
      path = ::Rails.root.join("data", "geo", "GeoWorldMap", "Countries.txt")
      
      countries = []
      n = 0
      CSV.foreach(path, col_sep: :",") do |tokens|
        n = n + 1
        unless n == 1
          countries << { :country_pk => tokens[0],
                         :name => tokens[1],
                         :fips104 => tokens[2],
                         :iso2 => tokens[3],
                         :iso3 => tokens[4],
                         :ison => tokens[5],
                         :internet => tokens[6],
                         :capital => tokens[7],
                         :map_reference => tokens[8],
                         :nationality_singular => tokens[9],
                         :nationaiity_plural => tokens[10],
                         :currency => tokens[11],
                         :currency_code => tokens[12],
                         :population => tokens[13],
                         :title => tokens[14]}
                         
        end
      end 
      
      puts "Done."
      
      puts 'Saving countries ...'
      bar = ProgressBar.new(countries.size)
      
      countries.each do |country|
        unless existing = Country.where(name: country[:name], country_pk: country[:country_pk]).first
          Country.new(country).save!
          bar.increment!
        end
      end
      puts 'Done.'
    end
  end
  
  namespace :regions do

    task load: :environment do
      puts 'Loading regions ...'
      path = ::Rails.root.join("data", "geo", "GeoWorldMap", "Regions.txt")
      
      regions = []
      n = 0
      CSV.foreach(path, col_sep: :",") do |tokens|
        n = n + 1
        unless n == 1
          regions << {   :region_pk => tokens[0],
                         :country_pk => tokens[1],
                         :name => tokens[2],
                         :code => tokens[3],
                         :adm1code => tokens[4]}
                         
        end
      end 
      
      puts "Done."
      
      puts 'Saving regions ...'
      bar = ProgressBar.new(regions.size)
      
      regions.each do |region|
        unless existing = Region.where(name: region[:name], country_pk: region[:region_pk]).first
          Region.new(region).save!
          bar.increment!
        end
      end
      puts 'Done.'
    end
  end  
  
  
  namespace :cities do

    task load: :environment do
      puts 'Loading cities ...'
      path = ::Rails.root.join("data", "geo", "GeoWorldMap", "Cities.txt")
      
      cities = []
      n = 0
      CSV.foreach(path, col_sep: :",") do |tokens|
        n = n + 1
        unless n == 1
          cities << {    :city_pk => tokens[0],
                         :country_pk => tokens[1],
                         :region_pk => tokens[2],
                         :name => tokens[3]}
                         
        end
      end 
      
      puts "Done."
      
      puts 'Saving cities ...'
      bar = ProgressBar.new(cities.size)
      
      cities.each do |city|
        unless existing = City.where(name: city[:name], country_pk: city[:city_pk]).first
          City.new(city).save!
          bar.increment!
        end
      end
      puts 'Done.'
      
    end
  end   
  
end
