# Development

## Required packages for local development
- sqlite3
    - data store
- redis
    - session store
    - codeboard
- libxml2
    - for nokogiri
- libxslt
    - for nokogiri

## Initial setup
```sh
bundle install
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml
# Note: you can generate secret_key_base by bin/rake secret.
bin/rake db:migrate
```

## Running local server
Make sure that Redis is running.

```sh
bin/rails s
```

## Testing
```sh
bin/rspec
```

## Running crawlers
```sh
bin/rake crawler:work
```
