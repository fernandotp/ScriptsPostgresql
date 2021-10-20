#!/bin/bash


sudo -u postgres psql -c "SELECT count(granted),mode,datname as database \
FROM pg_locks l JOIN pg_database d ON (d.oid=l.database) WHERE mode != 'AccessShareLock' GROUP BY mode,datname;"

sudo -u postgres psql -c "\l"
