#!/bin/bash

if [[ ! `id -u` -eq 0 ]]; then
	echo You must run this script as a superuser.
	exit 1
fi

if [[ ! `id -u entermedia 2> /dev/null` ]]; then
	groupadd -g $GROUPID entermedia
	useradd -ms /bin/bash entermedia -g entermedia -u $USERID
fi

# SIGTERM-handler
term_handler() {
    pid=$(cat /tmp/elasticsearch.pid)
if [[ ! -z $pid ]]; then
  if [ $pid -ne 0 ]; then
	echo "Deployment shutdown start"
    kill -SIGTERM "$pid"
	while [ -e /proc/$pid ]
	do
		printf .
		sleep 1
	done    
  fi
fi
  exit 143; # 128 + 15 -- SIGTERM
}


trap 'kill ${!}; term_handler' SIGTERM

# debug
sed "s:%cluster_name:$CLUSTER_NAME:g;s:%elasticsearch_address:$ELASTICSEARCH_ADDR:g;s:%entermediadb_address:$ENTERMEDIADB_ADDR:g;s:%elasticsearch_address:$ELASTICSEARCH_ADDR:g" < /usr/share/elasticsearch/config/elasticsearch.yml > /usr/share/elasticsearch/config/elasticsearch.yml.tmp
mv /usr/share/elasticsearch/config/elasticsearch.yml.tmp /usr/share/elasticsearch/config/elasticsearch.yml
cp /usr/share/elasticsearch/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
cp /usr/share/elasticsearch/config/logging.yml /etc/elasticsearch/
sudo chown entermedia:entermedia -R /usr/share/elasticsearch
sudo chown entermedia:entermedia -R /etc/elasticsearch

/usr/share/elasticsearch/bin/elasticsearch-systemd-pre-exec

# Run as entermedia search from the host OS
sudo -u entermedia sh -c "/usr/share/elasticsearch/bin/elasticsearch -Des.network.host=0.0.0.0 \
                                           -Des.pidfile=/tmp/elasticsearch.pid \
                                           -Des.default.path.home=/usr/share/elasticsearch \
                                           -Des.default.path.logs=/var/log/elasticsearch \
                                           -Des.default.path.data=/var/lib/elasticsearch \
                                           -Des.default.path.conf=/etc/elasticsearch" &  

while true
do
  wait ${!}
done
