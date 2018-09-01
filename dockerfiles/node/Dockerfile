FROM node:10-alpine

RUN apk update \
    && apk add \
      bash \
      curl \
      make \
    && rm -rf /var/cache/apk/*

# Upgrade yarn
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

CMD ["tail", "-f", "/dev/null"]
