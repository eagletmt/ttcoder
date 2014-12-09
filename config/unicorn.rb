worker_processes 2

app_path = File.expand_path('../..', __FILE__)

working_directory app_path
pid "#{app_path}/tmp/pids/unicorn.pid"
listen '/tmp/ttcoder.sock'

stderr_path "#{app_path}/log/unicorn-stderr.log"
stdout_path "#{app_path}/log/unicorn-stdout.log"

preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
