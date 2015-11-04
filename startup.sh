#!/bin/bash
# If $USERSCRIPT exists it gets executed. Must exit with a clean error code (0)!
USERSCRIPT=/user/init
if [ -e ${USERSCRIPT} ]; then
    chmod +x ${USERSCRIPT}
    ${USERSCRIPT}
fi
/etc/init.d/postgresql start
/usr/local/atlassian/confluence/bin/catalina.sh run

