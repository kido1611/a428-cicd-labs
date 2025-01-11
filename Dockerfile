FROM node:16-buster-slim AS builder

WORKDIR /app

COPY . .

RUN npm install && \
  npm run build

FROM nginx:alpine-perl AS runner

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/build .
