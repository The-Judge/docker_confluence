FROM java:7
# Adapted from http://bit.ly/1qZAmGA
MAINTAINER Marc Richter <mail@marc-richter.info>

# setup useful environment variables
ENV CONF_INST       /usr/local/atlassian/confluence
ENV CONF_HOME       ${CONF_INST}-data
ENV CONF_SETENV     ${CONF_INST}/bin/setenv.sh
ENV PG_VERSION      9.4
ENV DEBIAN_FRONTEND noninteractive

# Update System and install necessary packages
RUN set -x \
    && apt-get update -q \
    && apt-get dist-upgrade -y -q \
    && apt-get install -y -q postgresql-${PG_VERSION} postgresql-client
# Create needed folders
RUN set -x \
    && mkdir -p "${CONF_HOME}" "${CONF_INST}"
# Prepare PostgreSQL
RUN set -x \
    && sed -i'' 's/peer/trust/g' /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    && sed -i'' 's/md5/trust/g' /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    && /etc/init.d/postgresql start \
    && /usr/bin/psql -U postgres -c "CREATE DATABASE confluence ENCODING = UTF8;" \
    && /etc/init.d/postgresql stop

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8090

ENV CONF_VERSION    5.8.14
# Grab Confluence, extract it and prepare folders and configs
RUN set -x \
    && curl -Ls "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz" \
    | tar -xz --directory "${CONF_INST}/" --strip-components=1 \
    && chmod -R 777 "${CONF_INST}/temp" \
    && chmod -R 777 "${CONF_INST}/logs" \
    && chmod -R 777 "${CONF_INST}/work" \
    && echo -e "\nconfluence.home=${CONF_HOME}" >> "${CONF_INST}/confluence/WEB-INF/classes/confluence-init.properties"
# Tune Confluence Settings
RUN set -x \
    && sed -i'' 's#Xms256m#Xms1024m#g' ${CONF_SETENV} \
    && sed -i'' 's#Xmx512m#Xmx2048m#g' ${CONF_SETENV} \
    && sed -i'' 's#MaxPermSize=256m#MaxPermSize=2048m#g' ${CONF_SETENV} \
    && sed -i'' 's#^\(JAVA_OPTS.*\)"#\1-XX:-UseGCOverheadLimit"#g' ${CONF_SETENV}

VOLUME ["/var/atlassian/confluence", "/usr/local/atlassian/confluence", "/usr/local/atlassian/confluence-data", "/var/lib/postgresql"]

CMD ["/startup.sh"]
