Rails.application.config.current_version =
  if Rails.env.production?
    rev = Rails.root.join('REVISION').read.chomp
    rel = File.basename(Dir.pwd)
    link = "https://github.com/eagletmt/ttcoder/commit/#{rev}"
    %Q{<a href="#{link}">#{rev}</a><br>#{rel}}.html_safe
  else
    rev = `git rev-parse master`.chomp
    rel = Time.now.strftime('%Y%m%d%H%M%S')
    "#{rev}<br>#{rel}".html_safe
  end
