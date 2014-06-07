if Rails.env.development?
  require 'rubocop/rake_task'

  desc 'Scan by rubocop'
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.patterns = %w[--format emacs] + %w[app config lib spec].map { |prefix| prefix + '/**/*.rb' }
  end
end
