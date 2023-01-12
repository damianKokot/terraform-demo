FROM node:16.3.0-alpine

ENV AUTHOR="DamianK"

WORKDIR /usr/src/app

COPY package*.json .

RUN npm i

COPY . .

CMD ["node", "index.js"]
