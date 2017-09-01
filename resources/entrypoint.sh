#!/bin/bash

#
# Copyright (c) 2001-2018 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

set -e

if [ "X${1:0:1}" != 'X-' ]; then
  exec "$@"
fi

if [ -z "${JAVA_VM_MEM_MIN}" ]; then
  JVM_MIN_MEM=512
fi
if [ -z "${JAVA_VM_MEM_MAX}" ]; then
  JVM_MAX_MEM=1024
fi
if [ ${JAVA_VM_MEM_MIN} -gt ${JAVA_VM_MEM_MAX} ]; then
  echo "[`date`] [WARN ] JAVA_VM_MEM_MIN is bigger than JAVA_VM_MEM_MAX"
  JAVA_VM_MEM_MAX=${JAVA_VM_MEM_MIN}
fi

if [ -z "${SONARQUBE_JDBC_USERNAME}" ]; then
  SONARQUBE_JDBC_USERNAME=sonar
fi
if [ -z "${SONARQUBE_JDBC_PASSWORD}" ]; then
  SONARQUBE_JDBC_PASSWORD=sonar
fi
if [ -z "${SONARQUBE_JDBC_URL}" ]; then
  SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&autoReconnect=true&autoReconnectForPools=true&failOverReadOnly=false&rewriteBatchedStatements=true&useConfigs=maxPerformance"
fi

JAVA_OPTS="${JAVA_OPTS} -Xms${JAVA_VM_MEM_MIN}m -Xmx${JAVA_VM_MEM_MAX}m"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=utf-8 -Duser.timezone=Asia/Shanghai"
  
JAVA_OPTS="${JAVA_OPTS} -Dsonar.log.console=true"
JAVA_OPTS="${JAVA_OPTS} -Dsonar.jdbc.username=${SONARQUBE_JDBC_USERNAME}"
JAVA_OPTS="${JAVA_OPTS} -Dsonar.jdbc.password=${SONARQUBE_JDBC_PASSWORD}"
JAVA_OPTS="${JAVA_OPTS} -Dsonar.jdbc.url=${SONARQUBE_JDBC_URL}"
JAVA_OPTS="${JAVA_OPTS} -Dsonar.web.javaAdditionalOpts=$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom"

exec java ${JAVA_OPTS} -jar ${SONARQUBE_HOME}/lib/sonar-application-${SONARQUBE_VERSION}.jar "$@"