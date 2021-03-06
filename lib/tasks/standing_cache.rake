namespace :db do
  desc 'Cache standing of $U'
  task :standing_cache => [:environment] do
    unless ENV.key?('U')
      raise "Give me ENV['U']"
    end
    User.find_by!(name: ENV['U']).update_standing_cache!
  end
end
