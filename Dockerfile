# Pull base image.
FROM bash:devel-alpine3.15
LABEL maintainer="oochip2001@gmail.com"
RUN apk add --no-cache miniupnpc
RUN apk add --no-cache curl

COPY script.sh /bin/script.sh
COPY root /var/spool/cron/crontabs/root
RUN chmod +x /bin/script.sh
CMD crond -l 2 -f

# docker build -t oochip/upnp_ddns:1.0 .