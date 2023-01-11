#!/bin/sh

env >> /etc/environment

# start cron in the foreground (replacing the current process)
service cron start
supervisord -n
# Hand off to the CMD
exec "$@"
