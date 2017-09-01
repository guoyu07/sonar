# Readme

SonarQube is an open source platform for continuous inspection of code quality.

# Usage

    docker run -d --rm --name mysql -v /data/mysql:/var/lib/mysql primetoninc/mysql:5.6
    docker run -d --rm --name sonar --link mysql:mysql -p 9000:9000 primetoninc/sonar:6.3


    docker run -d --rm --name mysql -v /data/mysql:/var/lib/mysql \
        -e MYSQL_SONAR_DATABASE=sonar \
        -e MYSQL_SONAR_USER=sonar \
        -e MYSQL_SONAR_PASSWORD=sonar \
        primetoninc/mysql:5.6
    docker run -d --rm --name sonar --link mysql:mysql -p 9000:9000 \
        -e SONARQUBE_JDBC_USERNAME=sonar \
        -e SONARQUBE_JDBC_PASSWORD=sonar \
        -e SONARQUBE_JDBC_URL="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8&autoReconnect=true&autoReconnectForPools=true&failOverReadOnly=false&rewriteBatchedStatements=true&useConfigs=maxPerformance"
        primetoninc/sonar:6.3

    docker run -d --rm --name mysql -p 33306:3306 -v /data/mysql:/var/lib/mysql \
        -e MYSQL_SONAR_DATABASE=sonar \
        -e MYSQL_SONAR_USER=sonar \
        -e MYSQL_SONAR_PASSWORD=sonar \
        primetoninc/mysql:5.6
    docker run -d --rm --name sonar -p 9000:9000 \
        -e SONARQUBE_JDBC_USERNAME=sonar \
        -e SONARQUBE_JDBC_PASSWORD=sonar \
        -e SONARQUBE_JDBC_URL="jdbc:mysql://${mysql-docker-host}:33306/sonar?useUnicode=true&characterEncoding=utf8&autoReconnect=true&autoReconnectForPools=true&failOverReadOnly=false&rewriteBatchedStatements=true&useConfigs=maxPerformance"
        primetoninc/sonar:6.3
        