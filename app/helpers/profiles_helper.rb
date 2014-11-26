module ProfilesHelper
  def age_of_user( birthday )
    now = Time.now.utc.to_date
    age = nil
    if birthday
      age = now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
    end    
    return age
  end
end
