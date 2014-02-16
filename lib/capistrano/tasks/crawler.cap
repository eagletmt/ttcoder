namespace :crawler do
  desc 'Send QUIT signal to crawler'
  task :quit do
    on roles(:app) do
      unit_name = 'ttcoder-crawler.service'
      signal = :TERM

       main_pid = capture(:systemctl, 'show', unit_name, '--property', 'MainPID', '--no-pager')[/\AMainPID=(\d+)\z/, 1].to_i
       if main_pid == 0
         warn "#{unit_name} isn't running!"
       else
         execute(:kill, '-s', signal.to_s, main_pid)
       end
    end
  end
end

after 'deploy:publishing', 'crawler:quit'

# vim: set ft=ruby:
