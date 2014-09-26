# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ohio_parser'
set :repo_url, "git@github.com:ckuwanoe/#{fetch(:application)}.git"

# how many old releases do we want to keep
set :keep_releases, 5

# files we want symlinking to specific entries in shared.
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml config/initializers/setup_mail.rb}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system db/backups public/uploads public/downloads}

set(:config_files, %w(
  nginx.conf
  application.yml
  database.example.yml
  log_rotation
  monit
  unicorn.rb
  unicorn_init.sh
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/#{fetch(:full_app_name)}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
  }
])

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end






# Uncomment this line if your workers need access to the Rails environment:
#set :resque_environment_task, true
#set :whenever_roles, -> {:app}
#set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
#set :whenever_environment,  ->{ fetch :rails_env, "production" }
## this:
## http://www.capistranorb.com/documentation/getting-started/flow/
## is worth reading for a quick overview of what tasks are called
## and when for `cap stage deploy`
#set :bundle_flags, '--deployment'
#namespace :deploy do
#  # make sure we're deploying what we think we're deploying
#  before :deploy, "deploy:check_revision"
#  # only allow a deploy with passing tests to deployed
#  before :deploy, "deploy:run_tests"
#  # compile assets locally then rsync
#  after :updating, 'figaro:symlink'
#  #after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
#  after :finishing, 'cache:clear'
#  after :finishing, 'deploy:restart'
#  after :finishing, 'resque:restart'
#  after :finishing, 'resque:scheduler:restart'
#  after :finishing, 'deploy:cleanup'
#end