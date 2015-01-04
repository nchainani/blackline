# config valid only for current version of Capistrano
lock '3.3.5'

set :stages, %w(production staging)
set :default_stage, "staging"
set :rails_env, fetch(:stage)
set :deploy_env, fetch(:stage)

set :application, 'blackline'
set :repo_url, 'git@github.com:nchainani/blackline.git'

set :user, :blackline
set :tmp_dir, '/home/blackline/tmp'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/blackline/blackline'
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  desc 'Restart application'
  task :restart do
    # Reload unicorn with capistrano3-unicorn hook
    # needs to be before "on roles()"
    invoke 'unicorn:restart'
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
    end
  end
 
  after :finishing, 'deploy:cleanup'
  before :finishing, 'deploy:restart'
  after 'deploy:rollback', 'deploy:restart'
end