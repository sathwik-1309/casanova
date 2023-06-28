# Use the official Node.js image with nvm as the base image
FROM node:14.16.1

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

# Serve the built app using a lightweight web server (e.g., serve)
#RUN npm install -g serve

# Set the command to serve the app
CMD ["npm", "start"]
