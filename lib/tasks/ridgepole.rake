namespace :ridgepole do
  desc 'Run ridgepole --apply'
  task :apply do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', ENV.fetch('RAILS_ENV', 'development'), '--file', 'db/schema/Schemafile', '--apply'
  end

  desc 'Run ridgepole --apply --dry-run'
  task :'dry-run' do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', ENV.fetch('RAILS_ENV', 'development'), '--file', 'db/schema/Schemafile', '--apply', '--dry-run'
  end

  desc 'Run ridgepole --export'
  task :export do
    sh 'ridgepole', '--config', 'config/database.yml', '--env', ENV.fetch('RAILS_ENV', 'development'), '--output', 'db/schema/Schemafile', '--export', '--split'
  end
end
