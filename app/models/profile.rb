class Profile < ActiveRecord::Base
  
  ## association
  belongs_to :user
  # belongs_to :city


  ## validation
  validates :user,
    presence: true
=begin
  validates :city,
    presence: { unless: proc { |x| x.new_record? } } 
=end
     

  ALL_FIELDS = %w(birthday relationship_status about_me gender place)
  STRING_FIELDS = %w(relationship_status gender place)
  VALID_GENDERS = ["M", "F"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now  
  validates_length_of STRING_FIELDS,
                     :maximum => 255
  validates_inclusion_of :gender,
                          :in => VALID_GENDERS,
                          :allow_nil => true,
                          :message => "must be male or female"
  validates_inclusion_of :birthday,
                        :in => VALID_DATES,
                        :allow_nil => true,
                        :message => "is invalid"     


#  after_save :fix_counters, :if => ->(er) { er.city_id_changed? }

#  before_save :test

=begin
  def test
    raise self.inspect
  end
=end

  
private

  def fix_counters
    if self.city_id_was
      if old_city = City.includes(:region).where(id: self.city_id_was).first
        City.decrement_counter(:users_count, old_city.id)
        Region.decrement_counter(:users_count, old_city.region_id)
        Country.decrement_counter(:users_count, old_city.region.country_id)
      end
    end

    if new_city = City.includes(:region).where(id: self.city_id).first
      City.increment_counter(:users_count, new_city.id)
      Region.increment_counter(:users_count, new_city.region_id)
      Country.increment_counter(:users_count, new_city.region.country_id)
    end
  end

end