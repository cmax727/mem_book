class OAuthProviders
  FACEBOOK  = 1000
  TWITTER   = 2000
  GOOGLE    = 3000

  def self.id_range
    [FACEBOOK, TWITTER, GOOGLE]
  end

  def self.symbol_to_id(symbol)
    case symbol.is_a?(Symbol) ? symbol : symbol.to_s.to_sym
    when :facebook, :fb
      FACEBOOK
    when :twitter
      TWITTER
    when :google_oauth2
      GOOGLE
    else
      nil
    end
  end

  def self.id_to_symbol(id)
    case id
    when FACEBOOK
      :facebook
    when TWITTER
      :twitter
    when GOOGLE
      :google_oauth2
    else
      nil
    end
  end

end