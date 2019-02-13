set :rails_env, 'production'

set :deploy_to, '/var/www/vhosts/decidim-gava'
set :branch, 'master'
set :rails_env, :production

role :app, %w{THIS_IS_SECRET}
role :web, %w{THIS_IS_SECRET}
role :db,  %w{THIS_IS_SECRET}

set :ssh_options, {
  forward_agent: true
}

set :default_env, { path: "/home/deployer1/.rbenv/shims:/home/deployer1/.rbenv/bin:$PATH", rails_env: "production" }
#

namespace :deploy do
  task :precompile_assets do
    on roles(:app) do
      #execute "cd #{current_path};RAILS_ENV=production bundle exec rake assets:precompile --trace"
      #execute "cd #{current_path};ruby -v"
      #execute "cd #{current_path};ls -lah; cat .ruby-version"
      execute "export LANG=en_US.UTF-8"
      execute "export LANGUAGE=en_US.UTF-8"
      execute "export LC_ALL=en_US.UTF-8"
      within current_path do
        execute(:rake, 'assets:precompile')
      end
    end
  end
  desc "Symlink uploads"
  task :symlink_uploads do
    on roles(:app) do
      execute "ln -nfs #{deploy_to}/shared/uploads #{current_path}/public/uploads"
    end
  end
end

#after 'deploy', 'deploy:symlink_public'

after 'deploy', 'deploy:precompile_assets'
after 'deploy', 'deploy:symlink_uploads'
after 'deploy', 'puma:start'
