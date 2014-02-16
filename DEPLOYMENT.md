# Deployment
## Initial setup
Local host:

```sh
ssh-keygen -f ttcoder
mv ttcoder ~/.ssh/ttcoder.pem
scp ttcoder.pub systemd/ttcoder-crawler.service systemd/ttcoder.service remote-host:/tmp
```

Remote host:

```sh
sudo mkdir -m 700 ~ttcoder/.ssh
sudo mv /tmp/ttcoder.pub ~ttcoder/.ssh/authorized_keys
sudo chmod 600 ~ttcoder/.ssh/authorized_keys
sudo chown ttcoder:ttcoder -R ~ttcoder/.ssh
sudo mv /tmp/ttcoder-crawler.service /tmp/ttcoder.service /etc/systemd/system
sudo systemctl enable ttcoder.service
sudo systemctl enable ttcoder-crawler.service
```

Local host:

```sh
bin/cap production deploy:setup
bin/rake generate_secret_token
bin/cap production db:upload_config
bin/cap production secrets:upload
```

Remote host:

```sh
sudo systemctl start ttcoder.service
sudo systemctl start ttcoder-crawler.service
```

## Deploy
```sh
eval `ssh-agent`
ssh-add
bin/cap production deploy
```
