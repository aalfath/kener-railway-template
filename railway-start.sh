#!/bin/sh
set -e

# Public URL of this Kener instance (used for CSRF checks and links in emails).
# The template sets ORIGIN=https://${{RAILWAY_PUBLIC_DOMAIN}}; fall back to it if unset.
if [ -z "$ORIGIN" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  export ORIGIN="https://$RAILWAY_PUBLIC_DOMAIN"
fi

export PORT="${PORT:-3000}"

# Railway's private network can be IPv6-only. ioredis resolves IPv4 only unless
# family=0 is set, so add it to REDIS_URL when it isn't there already.
case "$REDIS_URL" in
  ""|*family=*) ;;
  *\?*) export REDIS_URL="${REDIS_URL}&family=0" ;;
  *) export REDIS_URL="${REDIS_URL}?family=0" ;;
esac

exec /app/docker-entrypoint.sh "$@"
