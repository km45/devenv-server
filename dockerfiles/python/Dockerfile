FROM python:3.6-alpine

RUN apk update \
    && apk add \
      bash \
      make \
    && rm -rf /var/cache/apk/*

#
# Install pipenv
#
RUN pip install pipenv

CMD [ "tail", "-f", "/dev/null" ]
