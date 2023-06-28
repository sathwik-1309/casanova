# Use the official Ruby image as the base image
FROM ruby:2.7.6

# Set the working directory inside the container
WORKDIR /backend

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Install dependencies using Bundler
RUN gem install bundler && bundle install

# Copy the rest of the application code to the working directory
COPY . .

# Start the Rails server
CMD ["puma", "-C", "config/puma.rb"]
