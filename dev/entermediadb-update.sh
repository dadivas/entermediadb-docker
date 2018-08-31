#!/bin/bash

#Can specify the build number like http://dev.entermediasoftware.com/jenkins/view/EM9DEV/job/em9dev_entermedia-server/2270/artifact/deploy/ROOT.war

wget -O /tmp/ROOT.war http://dev.entermediasoftware.com/jenkins/view/EM9DEV/job/em9dev_demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war > /dev/null
rm -rf /usr/share/entermediadb/webapp/WEB-INF/{base,lib,bin}
unzip /tmp/ROOT.war 'WEB-INF/base/*' -d /usr/share/entermediadb/webapp/ > /dev/null
unzip /tmp/ROOT.war 'WEB-INF/lib/*' -d /usr/share/entermediadb/webapp/ > /dev/null
unzip /tmp/ROOT.war 'WEB-INF/bin/*' -d /usr/share/entermediadb/webapp/ > /dev/null
chmod 755 /usr/share/entermediadb/webapp/WEB-INF/bin/linux/*.sh
rm /tmp/ROOT.war
/opt/entermediadb/tomcat/bin/shutdown.sh

