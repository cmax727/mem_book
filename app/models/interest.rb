class Interest < ActiveRecord::Base
  
  attr_accessible :name 
  
  validates :name, :presence => true, :uniqueness => true
  
  has_many :user_interests, dependent: :destroy
  has_many :users, :through => :user_interests
  has_many :owners,
           :through => :user_interests,
           :source => :user,
           :conditions => "related_type = 'owner'"
           
  
  has_many :members,
           :through => :user_interests,
           :source => :user,
           :conditions => "related_type = 'member'"
end
