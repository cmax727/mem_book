module ApplicationHelper
  def yield_for(content_sym, default = "", options = {})
    options = {} unless options.is_a?(Hash)

    if options[:mode].nil?
      if content_for?(content_sym)
        content_for(content_sym).html_safe
      else
        default.html_safe
      end
    else
      content = content_for?(content_sym) ? content_for(content_sym).html_safe : "".html_safe

      case options[:mode]
      when :prepend
        if content.blank?
          default.html_safe
        else
          "#{content} | #{default}".html_safe
        end
      else
        yield_for(content_sym, default)
      end
    end
  end
  
  def avatar_default_url
    
  end
 
end