class YogaFormBuilder < ActionView::Helpers::FormBuilder

  def initialize(*args)
    super(*args)
  end

  def error(method)
    error = @object.errors[method.is_a?(Symbol) ? method : method.to_s.to_sym]
    if error
      if error.is_a?(Array)
        if error.size > 0
          _errors = []
          error.each do |err|
            _errors << encode(err)
          end
          error = _errors.join("<br />").html_safe
        else
          error = nil
        end
      end
      @template.content_tag(:span, encode(error), :class => "error")
    end
  end

  def label(method, text = nil, options = {}, &block)
    text, options = nil, text if text.is_a?(Hash)
    options[:class] = "label" unless options.key?(:class)

    unless block_given?
      text = encode(text || translate(method) || method.to_s.humanize)

      super(method, text, options, &block)
    else
      @template.content_tag(:label, options, &block)
    end
  end

private

  def translate(method, default = "")
    I18n.t("models.#{@object_name}.#{method.to_s}", :default => default)
  end

  def translate_description(method, default = "")
    I18n.t("models.#{@object_name}._#{method.to_s}", :default => default)
  end

  def encode(value)
    value ||= "".html_safe

    value.html_safe? ? value : value.html_encode.html_safe
  end
end
