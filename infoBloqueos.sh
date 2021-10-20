#!/bin/bash

sudo -u postgres psql -c "SELECT count(granted),mode,datname as database \
FROM pg_locks l JOIN pg_database d ON (d.oid=l.database) WHERE mode != 'AccessShareLock' GROUP BY mode,datname;"

sudo -u postgres psql -c "SELECT \
    activity.pid, \
    activity.usename, \
    activity.query, \
    blocking.pid AS blocking_id, \
    blocking.query AS blocking_query \
FROM pg_stat_activity AS activity \
JOIN pg_stat_activity AS blocking ON blocking.pid = ANY(pg_blocking_pids(activity.pid));"
