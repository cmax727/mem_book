class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :picture
  belongs_to :discussion
  has_many   :flags, dependent: :destroy
end
