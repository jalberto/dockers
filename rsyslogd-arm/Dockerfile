FROM container4armhf/armhf-alpine:3.4

RUN apk add --no-cache rsyslogd
ADD etc/rsyslog.d /etc/
ADD etc/rsyslogd.conf /etc/
VOLUME /var/run/rsyslog/dev
ENTRYPOINT ["rsyslogd", "-n", "-f", "/etc/rsyslogd.conf"]
