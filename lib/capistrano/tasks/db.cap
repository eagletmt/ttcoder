namespace :db do
  desc 'Upload config/database.yml'
  task :upload_config do
    path = 'config/database.yml'
    on roles(:app) do
      upload!(path, shared_path.join(path))
    end
  end
end

# vim: set ft=ruby:
