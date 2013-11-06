set :application, "myapp"
set :scm, "git"
set :repository, "git@github.com:mindriot101/node-deploy-test.git"
set :branch, "master"
set :deploy_to, "/var/www/app"
set :deploy_via, :remote_cache
set :copy_strategy, :checkout
set :keep_releases, 5
set :use_sudo, false
set :copy_compression, :bz2
set :normalize_asset_timestamps, false
set :document_root, "/var/www/app"
set :ssh_options, { :forward_agent => true, :port => 2222 }
set :user, "deploy"

role :app, "127.0.0.1"

namespace :deploy do
  task :start, :roles => :app do
    run "sudo restart #{application} || sudo start #{application}"
  end

  task :stop, :roles => :app do
    run "sudo stop #{application}"
  end

  task :restart, :roles => :app do
    start
  end

  task :npm_install, :roles => :app do
    run "cd #{release_path} && npm install"
  end
end

after "deploy:update", "deploy:cleanup"
after "deploy:update_code", "deploy:npm_install"
