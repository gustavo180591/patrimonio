# Use Node.js 22 LTS with Debian for better compatibility
FROM node:22-slim AS builder

# Install necessary build tools
RUN apt-get update && apt-get install -y python3 make g++

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# List the build directory to debug
RUN ls -la build/ || echo "Build directory not found"

# Remove dev dependencies to reduce image size
RUN npm prune --production

# Create a new stage for the production image
FROM node:22-slim

# Set working directory
WORKDIR /app

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production

# Copy the built application from the builder stage
COPY --from=builder /app/build ./build
COPY --from=builder /app/static ./static

# Expose port (SvelteKit default is 3000)
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["node", "build/index.js"]
