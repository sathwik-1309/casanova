# Use the official Node.js Alpine image with nvm as the base image
FROM node:14.16.1-alpine as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies using npm
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app
RUN npm run build

# Use a lightweight web server to serve the built app
FROM node:14.16.1-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built app from the builder stage
COPY --from=builder /app/build ./build

# Serve the app using a lightweight web server (e.g., serve)
RUN npm install -g serve

# Set the command to serve the app
CMD ["serve", "-s", "build"]
