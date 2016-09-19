set :application, 'ttcoder'

set :scm, :git
set :branch, 'master'
set :deploy_to, '/home/ttcoder/ttcoder'
set :repo_url, 'https://github.com/eagletmt/ttcoder'
require 'sshkit/backends/libssh'
set :sshkit_backend, SSHKit::Backend::Libssh

set :user, 'ttcoder'
set :use_sudo, false

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w[config/secrets.yml config/database.yml .env]
set :linked_dirs, %w[log tmp/pids]

# set :keep_releases, 5

# capistrano-rails
set :rails_env, 'production'

# capistrano-bundler
set :bundle_flags, '--deployment -j4'
set :bundle_env_variables, {
  'BUNDLE_SOURCE' => ENV['BUNDLE_SOURCE'],
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
end

require 'capistrano/git'
module FullRevisionStrategy
  include Capistrano::Git::DefaultStrategy

  def fetch_revision
    context.capture(:git, "rev-list --max-count=1 #{fetch(:branch)}")
  end
end
set :git_strategy, FullRevisionStrategy
