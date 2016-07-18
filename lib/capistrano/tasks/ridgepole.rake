namespace :deploy do
  desc 'Run ridgepole:apply'
  task :migrate => [:set_rails_env] do
    on roles(:db) do
      within release_path do
        with(rails_env: fetch(:rails_env)) do
          execute :rails, 'ridgepole:apply'
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate'
end
