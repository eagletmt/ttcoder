namespace :npm do
  desc 'Run npm install'
  task :install do
    sh 'npm', 'install'
  end
end

task 'assets:precompile' => 'npm:install'
