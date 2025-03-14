FROM node:16-alpine as builder
WORKDIR '/app'

COPY package.json .
RUN npm install

RUN mkdir node_modules/.cache && chmod -R 777 node_modules/.cache

COPY . .

RUN npm run build 

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

FROM node:19.9.0-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . /app
RUN npm run build
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
