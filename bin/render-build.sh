#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

# Only seed if database is empty (no users exist)
if ! bundle exec rails runner "exit(User.exists? ? 0 : 1)" 2>/dev/null; then
  echo "Database is empty, running seeds..."
  bundle exec rake db:seed
else
  echo "Database already has data, skipping seeds."
fi 