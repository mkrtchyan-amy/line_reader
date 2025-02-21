#!/bin/bash

# Install bundler
gem install bundler

# Install dependencies
bundle install

# Start the Redis server in the background
redis-server &

# Wait for Redis to fully start
sleep 5

bundle exec rake create_file
bundle exec rake preprocess_file
