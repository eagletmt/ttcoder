namespace :secrets do
  desc 'Upload config/secrets.yml'
  task :upload do
    path = 'config/secrets.yml'
    on roles(:app) do
      upload!(path, shared_path.join(path))
    end
  end
end

# vim: set ft=ruby:
