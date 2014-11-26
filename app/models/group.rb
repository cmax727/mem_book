class Group < ActiveRecord::Base
  
  attr_accessible :name, :description, :tag, :ettiquette
  has_many :memberships, dependent: :destroy
  has_many :members,
           :through => :memberships,
           :source => :user,
           :conditions => "member_type = 'member' and status <> 'blocked'"
           
  has_many :owners,
           :through => :memberships,
           :source => :user,
           :conditions => "member_type = 'owner' and status <> 'blocked'"
           

  has_many :leaders,
           :through => :memberships,
           :source => :user,
           :conditions => "member_type = 'leader' and status <> 'blocked'"
           
  has_many :users,
           :through => :memberships,
           :source => :user,
           :conditions => "status <> 'blocked'"
           
  has_many :discussions, dependent: :destroy
  
  has_one  :setting
  
  attr_accessible :avatar
  
  has_attached_file :avatar, :styles => { :medium => "110x110>", :small => "97x97>", :main => "40x40>" }
  

end
