#!/bin/bash
# If $USERSCRIPT exists it gets executed. Must exit with a clean error code (0)!
USERSCRIPT=/user/init
if [ -e ${USERSCRIPT} ]; then
    chmod +x ${USERSCRIPT}
    ${USERSCRIPT}
fi
pg_ctlcluster ${PG_VERSION} main start -- -w
sleep 3
/usr/local/atlassian/confluence/bin/catalina.sh run
