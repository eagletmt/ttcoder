worker_processes 2

app_path = File.expand_path('../..', __FILE__)

pid "#{app_path}/tmp/pids/unicorn.pid"
listen '/tmp/ttcoder.sock'

stderr_path "#{app_path}/log/unicorn-stderr.log"
stdout_path "#{app_path}/log/unicorn-stdout.log"
