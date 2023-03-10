# To run the container locally:
docker run -d -v D:\Github\jvano\azure-appservice-tools\migration\java\tomcat:/tools --name tomcat-container tomcat
docker exec -it tomcat-container /bin/bash

# To populate apps:
# 1. Download sample war from:
cd /
wget https://tomcat.apache.org/tomcat-10.0-doc/appdev/sample/sample.war

# 2. Provision some apps in Tomcat:
ls ${CATALINA_HOME}/webapps/
cp /sample.war ${CATALINA_HOME}/webapps/root.war
cp /sample.war ${CATALINA_HOME}/webapps/app1.war
cp /sample.war ${CATALINA_HOME}/webapps/app2.war
ls ${CATALINA_HOME}/webapps/

# To run the dicovery tool
./tools/tomcat-dicovery.sh