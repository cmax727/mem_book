class City < ActiveRecord::Base
  attr_accessible :city_pk, :country_pk, :region_pk, :name
  
  self.primary_key = 'city_pk'
  belongs_to :country, :foreign_key => "country_pk"
  belongs_to :region, :foreign_key => "region_pk"
  
  def google_maps_query
    if self.region
      [self.name, self.region.name, self.country.name].compact.join(", ")
    else
      [self.name, self.country.name].compact.join(",")
    end
  end

=begin
  has_many :profiles

  searchable do
    text(:full_name, as: :full_name_ac)
  end



  def google_maps_src
    "https://maps.google.com/maps?f=q&amp;source=s_q&amp;geocode=&amp;q=#{URI.encode(self.google_maps_query)}&amp;aq=&amp;t=h&amp;ie=UTF8&amp;hq=&amp;z=12&amp;iwloc=A&amp;output=embed"
  end
=end

end