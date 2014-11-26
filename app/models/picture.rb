class Picture < ActiveRecord::Base
  attr_accessible :title, :avatar1, :caption, :permission
  
  belongs_to :user
  has_many   :comments, dependent: :destroy
  
  has_attached_file :avatar1, :styles => { :medium => "300x300>", :thumb => "27x27#" }
  
  def prev(user)
    Picture.first(:conditions => ['id < ? and user_id = ?', self.id, user.id], :order => 'id DESC')
  end

  def next(user)
    Picture.first(:conditions => ['id > ? and user_id = ?', self.id, user.id], :order => 'id ASC')
  end
 
end
