#!/bin/bash
pg_ctlcluster 9.4 main start -- -w
sleep 3
/usr/local/atlassian/confluence/bin/catalina.sh run

