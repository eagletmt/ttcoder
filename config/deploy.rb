# nokogiri >= 1.6.0
set :default_env, {
  'NOKOGIRI_USE_SYSTEM_LIBRARIES' => '1',
}
set :application, 'ttcoder'

set :scm, :git
set :branch, 'master'
set :deploy_to, '/home/ttcoder/deploy'
set :repo_url, 'git@bitbucket.org:eagletmt/ttcoder.git'

set :user, 'ttcoder'
set :use_sudo, false

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w[config/secrets.yml config/database.yml]
set :linked_dirs, %w[log tmp/pids]

# set :keep_releases, 5

# capistrano-rails
set :rails_env, 'production'

# capistrano-rbenv
set :rbenv_custom_path, '/usr/local/rbenv'
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

# capistrano-bundler
set :bundle_flags, '--deployment -j4'

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
