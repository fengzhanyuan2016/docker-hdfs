FROM java:7

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade

RUN apt-get install -qy rsync curl openssh-server openssh-client vim nfs-common

RUN mkdir -p /data/hdfs-nfs/
RUN mkdir -p /opt
WORKDIR /opt

# Install Hadoop
ADD https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/core/hadoop-2.7.7/hadoop-2.7.7.tar.gz .
ADD https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-2.3.7/apache-hive-2.3.7-bin.tar.gz .
ADD https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.49.tar.gz .

RUN tar -xzf hadoop-2.7.7.tar.gz && rm -rf hadoop-2.7.7.tar.gz
RUN tar -xzf apache-hive-2.3.7-bin.tar.gz && rm -rf apache-hive-2.3.7-bin.tar.gz
RUN tar -xzf mysql-connector-java-5.1.49.tar.gz && rm -rf mysql-connector-java-5.1.49.tar.gz

RUN mv hadoop-2.7.7 hadoop
RUN mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar apache-hive-2.3.7-bin/lib/
RUN mv apache-hive-2.3.7-bin hive

# Setup
WORKDIR /opt/hadoop
ENV PATH /opt/hadoop/bin:/opt/hadoop/sbin:/opt/hive/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME /opt/hadoop
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=/opt/hive/conf
RUN sed --in-place='.ori' -e "s/\${JAVA_HOME}/\/usr\/lib\/jvm\/java-7-openjdk-amd64/" etc/hadoop/hadoop-env.sh

# Configure ssh client
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa && \
    cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN echo "\nHost *\n" >> ~/.ssh/config && \
    echo "   StrictHostKeyChecking no\n" >> ~/.ssh/config && \
    echo "   UserKnownHostsFile=/dev/null\n" >> ~/.ssh/config

# Disable sshd authentication
RUN echo "root:root" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# => Quick fix for enabling datanode connections
#    ssh -L 50010:localhost:50010 root@192.168.99.100 -p 22022 -o PreferredAuthentications=password

# Pseudo-Distributed Operation
COPY core-site.xml etc/hadoop/core-site.xml
COPY hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY hive-site.xml /opt/hive/conf/hive-site.xml
COPY entrypoint.sh ./entrypoint.sh

RUN hdfs namenode -format



# SSH
EXPOSE 22
# hdfs://localhost:8020
EXPOSE 8020
# HDFS namenode
EXPOSE 50020
# HDFS Web browser
EXPOSE 50070
# HDFS datanodes
EXPOSE 50075
# HDFS secondary namenode
EXPOSE 50090

EXPOSE 10000
EXPOSE 10001
EXPOSE 10002

CMD [ "./entrypoint.sh" ]
