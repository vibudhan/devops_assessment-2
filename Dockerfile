# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---------- Stage 2: Run ----------
FROM node:20-slim
WORKDIR /app

# Copy standalone output from builder
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

# Non-root user for security
RUN useradd -m nextjs-user
USER nextjs-user

EXPOSE 3000
CMD ["node", "server.js"]


