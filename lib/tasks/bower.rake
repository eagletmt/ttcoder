namespace :bower do
  desc 'Run bower install'
  task :install do
    bowerrc = JSON.parse(File.read('.bowerrc'))
    sh 'mkdir', '-p', bowerrc['directory']
    sh 'bower', 'install'
  end
end

task 'assets:precompile' => 'bower:install'
