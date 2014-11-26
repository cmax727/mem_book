class Region < ActiveRecord::Base
  attr_accessible :region_pk, :country_pk, :name, :code, :adm1code
  
  self.primary_key = 'region_pk'
  belongs_to :country, :foreign_key => "country_pk"
  has_many :cities, :foreign_key => "region_pk"

end