FROM alpine:3.9

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache --virtual=.build-deps build-base libffi-dev libxslt-dev libxml2-dev python3-dev && \
    apk add --no-cache --virtual=.run-deps bash python3 curl ca-certificates jq libffi libxslt libxml2 && \
    python3 -m pip install -r requirements.txt && \
    apk del .build-deps

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
