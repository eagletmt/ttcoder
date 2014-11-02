# Deployment

## Required packages for production server
- postgresql
    - data store
- redis
    - session store
    - codeboard
- libxml2
    - for nokogiri
- libxslt
    - for nokogiri
- fluentd
    - logging

## Initial setup
### System configuration
The systemd units [ttcoder.service](systemd/ttcoder.service) and [ttcoder-crawler.service](systemd/ttcoder-crawler.service) assumes that:

- `ttcoder` user exists

### ttcoder configuration

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
cp config/database.yml.sample config/database.yml
vim config/database.yml
bin/cap production db:upload_config
cp config/secrets.yml.sample config/secrets.yml
vim config/secrets.yml
# Note: you can generate secret_key_base by bin/rake secret.
bin/cap production secrets:upload
```

Remote host:

```sh
sudo systemctl start ttcoder.service
sudo systemctl start ttcoder-crawler.service
```

## Deploy
```sh
bin/cap production deploy
```
