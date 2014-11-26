module TitleHelper

  def titles(*args)
    page_title(*args)
    inner_page_title(*args)
  end

  def page_title(*args)
    options = args.extract_options!

    literal = args.is_a?(Array) ? (args.size > 0 ? args[0] : nil) : nil
    literal = "#{get_key_prefix}.page_title".to_sym unless literal

    if literal.is_a?(Symbol)
      literal = I18n.t(literal, options)
    end

    unless literal.blank?
      content_for(:page_title) do
        "#{h(literal)}".html_safe
      end
    end
  end

  def inner_page_title(*args)
    options = args.extract_options!

    literal = args.is_a?(Array) ? (args.size > 0 ? args[0] : nil) : nil
    literal = "#{get_key_prefix}.inner_page_title".to_sym unless literal

    if literal.is_a?(Symbol)
      literal = I18n.t(literal, options).html_safe
    end

    unless literal.blank?
      content_for(:inner_page_title) do
        "<h2 class='title'>#{literal.html_safe? ? literal : h(literal)}</h2>".html_safe
      end
    end
  end

  def secondary_title(*args)
    options = args.extract_options!

    literal = args.is_a?(Array) ? (args.size > 0 ? args[0] : nil) : nil

    if literal.is_a?(Symbol)
      literal = I18n.t(literal, options).html_safe
    end

    unless literal.blank?
      "<h3>#{literal.html_safe? ? literal : h(literal)}</h3>".html_safe
    end
  end

private

  def get_key_prefix
    "#{params[:controller].gsub("/", ".")}.#{params[:action]}"
  end

end

