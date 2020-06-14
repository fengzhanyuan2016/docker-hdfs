FROM fengzhanyuan/hdfs

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade

RUN apt-get install -qy rsync curl openssh-server openssh-client vim nfs-common

RUN mkdir -p /opt
WORKDIR /opt

# Install Hadoop
ADD https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-2.3.7/apache-hive-2.3.7-bin.tar.gz .
ADD https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.49.tar.gz .
RUN tar -xzf apache-hive-2.3.7-bin.tar.gz && rm -rf apache-hive-2.3.7-bin.tar.gz
RUN tar -xzf mysql-connector-java-5.1.49.tar.gz && rm -rf mysql-connector-java-5.1.49.tar.gz
RUN mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar apache-hive-2.3.7-bin/lib/
RUN mv apache-hive-2.3.7-bin hive

# Setup
WORKDIR /opt/hive

ENV JAVA_HOME /usr/local/openjdk-8
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=/opt/hive/conf

ENV PATH /opt/hive/bin:$PATH


# Pseudo-Distributed Operation
COPY hive-site.xml /opt/hive/conf/hive-site.xml



CMD schematool -dbType mysql -initSchema \
  && hive
