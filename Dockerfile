FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build

# Clean up dev dependencies after build
RUN rm -rf node_modules && npm cache clean --force

#stage2 
FROM node:18-alpine AS runner

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci --production && npm cache clean --force

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./

ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm", "start"]
