Rails.application.config.current_version =
  if Rails.env.production?
    rev = `git --git-dir ../../repo rev-parse --short master`.chomp
    rel = File.basename(Dir.pwd)
    "#{rev} / #{rel}"
  else
    rev = `git rev-parse --short master`.chomp
    rel = Time.now.strftime('%Y%m%d%H%M%S')
    "#{rev} / #{rel}"
  end
