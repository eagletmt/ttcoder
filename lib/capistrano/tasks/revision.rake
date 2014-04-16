namespace :deploy do
  desc 'Write REVISION file'
  task :write_revision do
    on release_roles(:all) do
      execute "echo #{fetch(:current_revision)} > #{release_path.join('REVISION')}"
    end
  end

  before :updated, 'deploy:write_revision'
end

# vim: set ft=ruby:
