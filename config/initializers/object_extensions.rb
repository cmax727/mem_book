require 'rexml/document'
class Object

  def as_hash
    self.is_a?(Hash) ? self.dup : (self.respond_to?(:to_hash) ? self.to_hash : {})
  end

  def as_hash!
    replace_self(as_hash)
  end

  def url_encode
    EscapeUtils.escape_url(self.to_s)
  end

  def url_encode!
    replace_self(url_encode)
  end

  def url_decode
    EscapeUtils.unescape_url(self.to_s)
  end

  def url_decode!
    replace_self(url_decode)
  end

  def html_encode
    if self.is_a?(String)
      self.html_safe? ? self : EscapeUtils.escape_html(self)
    else
      val = self.to_s
      val.html_safe? ? val : EscapeUtils.escape_html(val)
    end
  end

  def html_encode!
    replace_self(html_encode)
  end

  def html_decode
    EscapeUtils.unescape_html(self.to_s)
  end

  def html_decode!
    replace_self(html_decode)
  end

  def xml_encode
    REXML::Text::normalize(self.to_s)
  end
end