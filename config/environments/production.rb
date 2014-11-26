AroundYoga::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  ignore = ["application.css", "application.js"]

  # Precompile our javascripts
  javascripts_directory = File.join(config.root, "app", "assets", "javascripts")
  js_pattern = File.join(javascripts_directory, "**", "*.js*")
  javascripts =
    Dir.glob(js_pattern).
      map{ |f| f[(javascripts_directory.size + 1)..( -1 )] }.
      map { |f| f.gsub(/\.js\..+/, ".js") }.
      select do |file|
        if config.assets.precompile.include?(file)
          false
        elsif File.basename(file)[0...1] == "_"
          false
        else
          true
        end
      end
  config.assets.precompile += javascripts

  # Precompile our stylesheets
  stylesheets_directory = File.join(config.root, "app", "assets", "stylesheets")
  style_pattern = File.join(stylesheets_directory, "**", "*.css*")
  stylesheets =
    Dir.glob(style_pattern).
      map{ |f| f[(stylesheets_directory.size + 1)..( -1 )] }.
      map { |f| f.gsub(/\.css\..+/, ".css") }.
      select do |file|
        if config.assets.precompile.include?(file)
          false
        elsif File.basename(file)[0...1] == "_"
          false
        else
          true
        end
      end
  config.assets.precompile += stylesheets

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.raise_delivery_errors = true 
  config.action_mailer.default_url_options = { :host => Settings.app.host }
  # config.action_mailer.default_url_options = { :host => 'http://aroundyoga-sheng-step6.herokuapp.com/' }
  config.action_mailer.smtp_settings = {
      :enable_starttls_auto => Settings.smtp.tls,
      :address => Settings.smtp.address,
      :port => Settings.smtp.port,
      :domain => Settings.smtp.domain,
      :authentication => Settings.smtp.authentication.to_sym,
      :user_name => Settings.smtp.user_name,
      :password => Settings.smtp.password
    }
  

=begin
  config.middleware.use ::ExceptionNotifier,
    :email_prefix => "[" + Settings.app.name + "] ",
    :sender_address => Settings.exceptions.sender,
    :exception_recipients => Settings.exceptions.recipients
=end

end
