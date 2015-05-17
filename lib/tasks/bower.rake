namespace :bower do
  desc 'Run bower install'
  task :install do
    sh 'bower', 'install'
  end
end

task 'assets:precompile' => 'bower:install'
