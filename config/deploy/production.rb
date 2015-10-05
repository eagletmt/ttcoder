set :stage, :production

server(
  'ttc.wanko.cc',
  user: 'ttcoder',
  roles: %w[web app db],
  ssh_options: {
    user: 'ttcoder',
    keys: File.expand_path('~/.ssh/ttcoder.pem'),
  }
)
