#!/usr/bin/env bash
# Copyright (c) Microsoft Corporation.  All rights reserved.
# Purpose: Discovery of Java app workloads to migrate to Azure App Service
# Description: Stop gap interim solution until Azure Migrate comes into fruition
# Assumptions: Need right level of access to execute the shell scripts
# Audience: Customers / Partners
# Output items:
#  Version of JDK
#  Identify wars
#  Location of wars
#  Generate Azure CLI commands
clear

cat >/etc/motd <<EOL 
        _|_|                                            
      _|    _|  _|_|_|_|  _|    _|  _|  _|_|    _|_|    
      _|_|_|_|      _|    _|    _|  _|_|      _|_|_|_|  
      _|    _|    _|      _|    _|  _|        _|        
      _|    _|  _|_|_|_|    _|_|_|  _|          _|_|_|
      
                 A P P  S E R V I C E
             D I C O V E R Y  T O O L  F O R
              T O M C A T  W E B  A P P S
    
EOL
cat /etc/motd

if [[ -z $JAVA_HOME ]]
then
    echo -e "ERROR: Java runtime not found!"    
    exit 0
fi

export JAVA_MAJOR=$(echo $JAVA_VERSION | grep -oP '\d+' | head -1)

echo Java Runtime Path: ${JAVA_HOME}
echo Java Runtime Major Version: ${JAVA_MAJOR}
echo Java Runtime Full Version: ${JAVA_VERSION}
echo

if [[ -z $CATALINA_HOME ]]
then
    echo -e "ERROR: Tomcat middleware not found!"
    exit 0
fi

echo Tomcat middleware Path: ${CATALINA_HOME}
echo Tomcat middleware Major Version: ${TOMCAT_MAJOR}
echo Tomcat middleware Full Version: ${TOMCAT_VERSION}
echo Tomcat middleware configuration file path: ${CATALINA_HOME}/conf/server.xml
echo

for filepath in ${CATALINA_HOME}/webapps/*.war 
do 
    [[ -f "$filepath" ]] || continue

    export APP_NAME=$(basename ${filepath%.*})
    echo "The following Tomcat Web App has been detected: $APP_NAME"
    echo

    echo "# The following Azure CLI commands Script for $(basename ${filepath%.*})"
    echo az webapp create --resource-group \${RESOURCE_GROUP} --name \${$(basename ${filepath%.*})_WEBAPP} --plan \${APPSERVICE_PLAN} --runtime "TOMCAT:${TOMCAT_MAJOR}.0-java$JAVA_MAJOR"
    echo az webapp deploy --resource-group \${RESOURCE_GROUP} --name \${$(basename ${filepath%.*})_WEBAPP} --type war --src-path "$filepath"
    echo 
done

echo "For other option for Tomcat versions on Azure App Service please use the following command:"
echo "az webapp list-runtimes --os linux"
echo

echo "For more information, please check out documentation on Azure.com:"
echo "https://learn.microsoft.com/en-us/azure/app-service/quickstart-java"
echo