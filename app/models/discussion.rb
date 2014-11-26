class Discussion < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :user
  belongs_to :group
  
  has_many   :comments, dependent: :destroy
  
  has_many  :discussion_followers, dependent: :destroy
            
  has_many  :followers,
            :through => :discussion_followers,
            :source => :user
end
