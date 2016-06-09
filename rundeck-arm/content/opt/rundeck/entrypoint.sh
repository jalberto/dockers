#!/bin/sh -l

set -e

[ -z "$*" ] || exec "$@"

# Look for base directory
CURDIR=$(cd `dirname $0/` && pwd)

if [ -r "${RDECK_BASE:=$CURDIR}"/etc/profile ]; then
  . "$RDECK_BASE"/etc/profile >/dev/null
elif [ -r /etc/rundeck/profile ]; then
  . /etc/rundeck/profile
fi

# Check basic permission
if [ -z "${RDECK_BASE}" -o ! -r "$RDECK_BASE"/rundeck-launcher-*.jar ]; then
  echo "Unable to determine RDECK_BASE." 1>&2
  exit 1
fi
if [ ! -w "$RDECK_BASE"/var ]; then
  echo "RDECK_BASE dir not writable: $RDECK_BASE" 1>&2
  exit 2
fi

# lookup the server port from the tools config file
if [ -z "$RDECK_PORT" -a -r "$RDECK_BASE"/etc/framework.properties ]; then
  RDECK_PORT=$(awk '/framework.server.port/ {print $3}' "$RDECK_BASE"/etc/framework.properties)
fi
if [ "${RDECK_PORT:-4440}" != 4440 ]; then
  RDECK_OPTS="$RDECK_OPTS -Dserver.http.port=\"$RDECK_PORT\""
fi

# set the ssl opts if https is configured
SSL_OPTS=
if [ -r "$RDECK_BASE"/etc/framework.properties ]; then
  proto=$(awk '/framework.server.url = / {split($3, a, ":"); print a[1]}' "$RDECK_BASE"/etc/framework.properties)
  if [ "${proto:-http}" = "https" ]; then
    RDECK_OPTS="$RDECK_OPTS -Drundeck.ssl.config=\"$RDECK_BASE\"/server/config/ssl.properties"
    if [ "${RDECK_PORT:-4443}" != 4443 ]; then
      RDECK_OPTS="$RDECK_OPTS -Dserver.https.port=\"$RDECK_PORT\""
    fi
  fi
fi

# java 8 fix
RDECK_JVM=$(echo "$RDECK_JVM" | sed 's/-XX:MaxPermSize=[^ ]*//g')

exec java $RDECK_JVM $RDECK_OPTS -jar "$RDECK_BASE"/rundeck-launcher-*.jar
