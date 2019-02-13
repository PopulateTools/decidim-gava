workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count
stdout_redirect 'log/puma.log', 'log/puma_error.log', true
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

# plugin 'tmp_restart'

preload_app!

activate_control_app

rackup DefaultRackup

port ENV['PORT'] || 3001
env= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :staging || :production
environment env
daemonize [:production, :staging, :integration].include?(env)

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
