#!/bin/bash

# Run rails db:drop
echo "Running rails db:create..."
rails db:drop

# Run rails db:create
echo "Running rails db:create..."
rails db:create

# Run rails db:migrate
echo "Running rails db:migrate..."
rails db:migrate

echo "Seeding data..."
rails r scripts/seed.rb

echo "Seeding existing matches..."
rails r scripts/existing.rb

# Run rails s (server)
echo "Starting Rails server..."
rails s -p
