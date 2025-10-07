# --- 1. BUILDER STAGE ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY . .
RUN npm run build

# --- 2. PRODUCTION RUNNER STAGE ---
FROM node:20-slim AS runner
RUN adduser --system --uid 1001 nextjs-user
USER nextjs-user
WORKDIR /app
ENV NODE_ENV production
ENV PORT 3000

# Copy only the standalone output and necessary assets
COPY --from=builder --chown=nextjs-user:nextjs-user /app/.next/standalone ./
COPY --from=builder --chown=nextjs-user:nextjs-user /app/public ./public
COPY --from=builder --chown=nextjs-user:nextjs-user /app/.next/static ./.next/static

EXPOSE ${PORT}
CMD ["node", "server.js"]
