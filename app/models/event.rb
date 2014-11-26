class Event < ActiveRecord::Base
  attr_accessible :name, :description, :place, :address, :started_at, :ended_at, :contact, :cost 
  
  has_many :user_events, dependent: :destroy
  has_many :users, :through => :user_events
  has_many :owners,
           :through => :user_events,
           :source => :user,
           :conditions => "related_type = 'owner'"
           
  
  has_many :attenders,
           :through => :user_events,
           :source => :user,
           :conditions => "related_type = 'attender'"
end
