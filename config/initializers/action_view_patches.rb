# ActionView::Base.default_form_builder = AdminFormBuilder

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<label/
    %|<span class="formerror">#{[instance.error_message].join(', ').html_encode}</span>#{html_tag}|.html_safe
  else
    html_tag
  end
end

