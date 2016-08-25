FROM centos:latest
MAINTAINER "EnterMedia" <help@entermediadb.org>
ENV CLIENT_NAME=entermedia
ENV INSTANCE_PORT=8080
ENV USERID=9009
ENV GROUPID=9009
COPY resolv.conf /etc/resolv.conf
RUN groupadd entermedia -g $GROUPID
RUN useradd entermedia -u $USERID -g $GROUPID
RUN yum -y install --nogpgcheck wget
RUN /usr/bin/wget -O /etc/yum.repos.d/entermedia.repo http://packages.entermediadb.org/repo/centos/7/x86_64/entermedia.repo
RUN yum -y install entermediadb_em9dev
ADD ./entermediadb-deploy /usr/bin/entermediadb-deploy
RUN chmod 755 /usr/bin/entermediadb-deploy
USER entermedia
CMD ["/usr/bin/entermediadb-deploy"]
