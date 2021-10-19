#!/bin/bash
# This shell script calls pg_dumpall and pipes into the gzip utility, then directs to
# a directory for storage.
# $(date +"%Y_%m_%d") incorporates the current system date into the file name.
  
pg_dumpall -U postgres | gzip > ~/Cluster_Dumps/$(date +"%Y_%m_%d")_pg_bck.gz
