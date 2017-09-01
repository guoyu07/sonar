#
# Copyright (c) 2001-2018 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM primetoninc/jdk:1.8

# LABEL maintainer="lizw@primeton.com" \
#     provider="Primeton Technologies, Ltd."

ENV SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_VERSION=6.3 \
    SONARQUBE_PORT=9000 \
    JAVA_VM_MEM_MIN=1024 \
    JAVA_VM_MEM_MAX=8192 \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&autoReconnect=true&autoReconnectForPools=true&failOverReadOnly=false&rewriteBatchedStatements=true&useConfigs=maxPerformance"

# Copy from official Dockerfile
RUN set -x \

    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \

    && cd /opt \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip \
    && curl -o sonarqube.zip.asc -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && \mv -f sonarqube-${SONARQUBE_VERSION} sonarqube \
    && \rm -f sonarqube.zip* \
    && \rm -rf $SONARQUBE_HOME/bin/*


RUN \rm -f ${SONARQUBE_HOME}/extensions/plugins \
    && curi -o /tmp/plugins.tar.gz -fSL https://doc-0g-bc-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/6c24mo8qfvi34qo8r1t9lau66012eo0i/1504252800000/05713710580929286757/*/0B8p5w2HKib3OVUlScXZKUjRoYk0?e=download \
    && tar -zvxf /tmp/plugins.tar.gz -C ${SONARQUBE_HOME}/extensions/ \
    && \rm -f /tmp/plugins.tar.gz

# http 9000
EXPOSE ${SONARQUBE_PORT}

# /opt/sonarqube/data
VOLUME ${SONARQUBE_HOME}/data

ADD resources/entrypoint.sh ${SONARQUBE_HOME}/bin/entrypoint.sh

RUN chmod +x ${SONARQUBE_HOME}/bin/entrypoint.sh

# /opt/sonarqube
WORKDIR ${SONARQUBE_HOME}

ENTRYPOINT [ "./bin/entrypoint.sh"]
