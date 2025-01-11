FROM node:16-buster-slim AS builder

WORKDIR /app

COPY . .

RUN npm install && \
  npm run build

# EXPOSE 3000
#
# CMD [ "npm", "start" ]
#
FROM nginx:alpine-perl AS runner
WORKDIR /usr/share/nginx/html

COPY --from=builder /app/build .
