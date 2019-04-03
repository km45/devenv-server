FROM node:current-alpine

RUN apk update \
    && apk add bash \
    && rm -rf /var/cache/apk/*

RUN npm install -g jsonlint

CMD ["tail", "-f", "/dev/null"]
