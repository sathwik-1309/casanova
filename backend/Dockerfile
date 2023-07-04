# Use the official Ruby Alpine image as the base image
FROM ruby:2.7.6-alpine

# Set the working directory inside the container
WORKDIR /backend

# Install system dependencies
RUN apk update && apk add --no-cache build-base

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Install dependencies using Bundler
RUN gem install bundler && bundle install --without development test

# Copy the rest of the application code to the working directory
COPY . .

# Start the Rails server
ENTRYPOINT ["puma", "-C", "config/puma.rb"]
