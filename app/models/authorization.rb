class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :user,
    :presence => true

  validates :provider_id,
    :uniqueness => { :scope => :user_id },
    :inclusion => { :in => OAuthProviders.id_range }

end