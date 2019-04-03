FROM python:3-alpine

RUN apk update \
    && apk add bash \
    && rm -rf /var/cache/apk/*

RUN pip install yamllint

CMD [ "tail", "-f", "/dev/null" ]
