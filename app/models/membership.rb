class Membership < ActiveRecord::Base
  attr_accessible :member_type, :status 
  belongs_to :user
  belongs_to :group
end
