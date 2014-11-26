class Flag < ActiveRecord::Base
  attr_accessible :innapropriate, :off_topic, :offensive
  belongs_to :user
  belongs_to :comment
end
