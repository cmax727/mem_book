class Country < ActiveRecord::Base
  attr_accessible :country_pk, 
                  :name, 
                  :fips104, 
                  :iso2, 
                  :iso3, 
                  :ison,
                  :internet, 
                  :capital, 
                  :map_reference, 
                  :nationality_singular, 
                  :nationaiity_plural, 
                  :currency, 
                  :currency_code, 
                  :population, 
                  :title
  
  
  self.primary_key = 'country_pk'
  has_many :regions, :foreign_key => "country_pk"
  has_many :cities, :foreign_key => "country_pk"

end