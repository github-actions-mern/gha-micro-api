## Stage 1 (production base)
# This gets our prod dependencies installed and out of the way

FROM node:14.15.4-slim as base

EXPOSE 8000

ENV NODE_ENV=production

ENV PATH=/app/node_modules/.bin:$PATH

WORKDIR /app

COPY package*.json ./

# we use npm ci here so only the package-lock.json file is used
RUN npm ci && npm cache clean --force

# healtcheck'de curl kullanabilmek için curl install ediyoruz
# RUN apt-get update && apt-get install curl -y

## Stage 2 (development)
# we don't COPY in this stage because for dev you'll bind-mount anyway
# this saves time when building locally for dev via docker-compose
FROM base as dev

ENV NODE_ENV=development

WORKDIR /app

RUN npm install --only=development

# CMD ["nodemon", "./bin/www", "--inspect=0.0.0.0:9229"]
CMD ["nodemon", "index.js"] 

## Stage 3 (copy in source for prod)
# This gets our source code into builder
# this stage starts from the first one and skips dev
FROM base as prod

COPY . .

# CMD ["node", "./bin/www"]
CMD ["node", "index.js"]