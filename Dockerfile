# Use Node.js 22 LTS Alpine for smaller image size
FROM node:22-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Remove dev dependencies to reduce image size
RUN npm prune --production

# Create a new stage for the production image
FROM node:22-alpine

# Set working directory
WORKDIR /app

# Copy only the built application and production dependencies from the previous stage
COPY --from=0 /app/package*.json ./
COPY --from=0 /app/build ./build
COPY --from=0 /app/node_modules ./node_modules

# Expose port (SvelteKit default is 3000)
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["node", "build/index.js"]
