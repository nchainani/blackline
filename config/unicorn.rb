# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 4)
timeout 15
preload_app true

system("mkdir -p /home/blackline/blackline/shared/pids")
system("mkdir -p /home/blackline/blackline/shared/logs")
pid "/home/blackline/blackline/shared/pids/unicorn.pid"
stderr_path "/home/blackline/blackline/shared/logs/unicorn.stderr.log"
stdout_path "/home/blackline/blackline/shared/logs/unicorn.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end