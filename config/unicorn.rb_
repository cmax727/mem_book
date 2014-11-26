if ENV['RAILS_ENV'] == 'development'
  listen '0.0.0.0:3000'
  worker_processes = 1
else
  # App isolation
  APP_USER  = ENV["APP_USERNAME"]                   # ruby
  APP_GROUP = ENV["APP_USERGROUP"]                  # ruby
  APP_NAME  = ENV["APP_NAME"]                       # aroundyoga.zerfis.com
  APP_ROOT  = ENV["APP_ROOT"]                       # /home/ruby/apps/aroundyoga.zerfis.com

  # Web
  WEB_ROOT = File.join(APP_ROOT, "current")         # APP_ROOT/current

  # Shared
  SHARED_ROOT = File.join(APP_ROOT, "shared")       # APP_ROOT/shared
  CONFIG_ROOT = File.join(SHARED_ROOT, "config")    # SHARED_ROOT/config
  SOCKETS_ROOT = File.join(SHARED_ROOT, "sockets")  # SHARED_ROOT/sockets
  PIDS_ROOT = File.join(SHARED_ROOT, "pids")        # SHARED_ROOT/pids
  LOGS_ROOT = File.join(SHARED_ROOT, "logs")        # SHARED_ROOT/logs

  worker_processes 2
  user APP_USER, APP_GROUP # user, group

  working_directory WEB_ROOT

  # listen on both a Unix domain socket and a TCP port,
  # we use a shorter backlog for quicker failover when busy
  listen File.join(SOCKETS_ROOT, ".sock"), :backlog => 64

  # nuke workers after 30 seconds instead of 60 seconds (the default)
  timeout 5

  # feel free to point this anywhere accessible on the filesystem
  pid File.join(PIDS_ROOT, "unicorn.pid")

  stderr_path File.join(LOGS_ROOT, "unicorn.err.log")
  stdout_path File.join(LOGS_ROOT, "unicorn.out.log")

  preload_app true
  if GC.respond_to?(:copy_on_write_friendly=)
    GC.copy_on_write_friendly = true
  end

  before_fork do |server, worker|

    ##
    # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
    # immediately start loading up a new version of itself (loaded with a new
    # version of our app). When this new Unicorn is completely loaded
    # it will begin spawning workers. The first worker spawned will check to
    # see if an .oldbin pidfile exists. If so, this means we've just booted up
    # a new Unicorn and need to tell the old one that it can now die. To do so
    # we send it a QUIT.
    #
    # Using this method we get 0 downtime deploys.

    old_pid = "#{server.config[:pid]}.oldbin"
    if File.exists?(old_pid) && server.pid != old_pid
      begin
        Process.kill("QUIT", File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
        # someone else did our job for us
      end
    end

    # The following is only recommended for memory/DB-constrained
    # installations.  It is not needed if your system can house
    # twice as many worker_processes as you have configured.
    #
    # # This allows a new master process to incrementally
    # # phase out the old master process with SIGTTOU to avoid a
    # # thundering herd (especially in the "preload_app false" case)
    # # when doing a transparent upgrade.  The last worker spawned
    # # will then kill off the old master process with a SIGQUIT.
    # old_pid = "#{server.config[:pid]}.oldbin"
    # if old_pid != server.pid
    #   begin
    #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
    #     Process.kill(sig, File.read(old_pid).to_i)
    #   rescue Errno::ENOENT, Errno::ESRCH
    #   end
    # end
    #
    # Throttle the master from forking too quickly by sleeping.  Due
    # to the implementation of standard Unix signal handlers, this
    # helps (but does not completely) prevent identical, repeated signals
    # from being lost when the receiving process is busy.
    # sleep 1
  end

  after_fork do |server, worker|

    # the following is *required* for Rails + "preload_app true",
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection

    # if preload_app is true, then you may also want to check and
    # restart any other shared sockets/descriptors such as Memcached,
    # and Redis.  TokyoCabinet file handles are safe to reuse
    # between any number of forked children (assuming your kernel
    # correctly implements pread()/pwrite() system calls)
  end
end