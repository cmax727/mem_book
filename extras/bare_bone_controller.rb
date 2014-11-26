module BareBoneController

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)

    base.protect_from_forgery

    base.helper(:all)

    base.before_filter(:set_cache_buster)
    base.before_filter(:fix_invalid_format)
    base.before_filter(:reject_underscore_param)
  end

  module ClassMethods

  protected

    def allow_formats!(*args)
      options = args.extract_options!
      formats = []

      # collect the valid formats
      args.each do |arg|
        if arg.is_a?(Symbol)
          formats << arg
        elsif format.respond_to?(:to_s)
          val = format.to_s
          formats << val.to_sym if val.size > 0
        end
      end

      formats.compact!
      formats.uniq!

      if formats.size > 0
        before_filter(options) do |c|
          c.instance_eval do
            render_406 unless formats.include?(request.format.to_sym)
          end
        end
      end
    end
    def allow_format!(*args) ; allow_formats!(*args) ; end

    def reject_formats!(*args)
      options = args.extract_options!
      formats = []

      # collect the invalid formats
      args.each do |arg|
        if arg.is_a?(Symbol)
          formats << arg
        elsif format.respond_to?(:to_s)
          val = format.to_s
          formats << val.to_sym if val.size > 0
        end
      end

      formats.compact!
      formats.uniq!

      if formats.size > 0
        before_filter(options) do |c|
          c.instance_eval do
            render_406 if formats.include?(request.format.to_sym)
          end
        end
      end
    end
    def reject_format!(*args) ; reject_formats!(*args) ; end
  end

  module InstanceMethods

  protected

    def notice(what, now = false)
      my_flash(what, :notice, now)
    end

    def warning(what, now = false)
      my_flash(what, :warning, now)
    end

    def error(what, now = false)
      my_flash(what, :error, now)
    end

    def alert(what, now = false)
      my_flash(what, :alert, now)
    end

    def my_flash(what, level = :notice, now = false)
      message = what.to_s

      unless message.blank?
        if now
          flash.now[level] = [] unless flash.now[level]
          flash.now[level] << message
        else
          flash[level] = [] unless flash[level]
          flash[level] << message
        end
      end
    end

  private

    def reject_underscore_param
      params.delete("_")
    end

    def fix_invalid_format
      request.format = :html if (request.format.nil? || request.format.to_sym.nil?) && request.formats == ["*/*"]
    end

    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end

end