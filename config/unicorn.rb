# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 4)
timeout 15
preload_app true

system("mkdir -p /home/blackline/blackline/shared/pids")
system("mkdir -p /home/blackline/blackline/shared/log")
pidfile = "/home/blackline/blackline/shared/pids/unicorn.pid"
pid pidfile
stderr_path "/home/blackline/blackline/shared/log/unicorn.stderr.log"
stdout_path "/home/blackline/blackline/shared/log/unicorn.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

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
  old_pid = pidfile + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end