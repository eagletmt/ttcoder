namespace :unicorn do
  desc 'Send USR2 signal to Unicorn'
  task :restart do
    on roles(:app) do
      unit_name = 'ttcoder.service'
      signal = :USR2

      main_pid = capture(:systemctl, 'show', unit_name, '--property', 'MainPID', '--no-pager')[/\AMainPID=(\d+)\z/, 1].to_i
      if main_pid == 0
        warn "#{unit_name} isn't running!"
      else
        execute(:kill, '-s', signal.to_s, main_pid)
      end
    end
  end
end

after 'deploy:publishing', 'unicorn:restart'

# vim: set ft=ruby:
