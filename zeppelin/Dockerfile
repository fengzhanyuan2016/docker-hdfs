FROM openjdk:8

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update

RUN apt-get install -qy rsync curl openssh-server openssh-client vim

RUN mkdir -p /opt
WORKDIR /opt

# Install Hadoop
RUN curl -L https://mirrors.tuna.tsinghua.edu.cn/apache/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz -s -o - | tar -xzf -
RUN mv zeppelin-0.8.2-bin-netinst zeppelin

# Setup
WORKDIR /opt/zeppelin
COPY zeppelin-site.xml conf/zeppelin-site.xml

RUN ls .
ENV PATH /opt/zeppelin/bin:$PATH
ENV JAVA_HOME /usr/local/openjdk-8


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



# SSH
EXPOSE 22
# hdfs://localhost:8020
EXPOSE 8080


CMD service ssh start \
  && zeppelin-daemon.sh start \
  && sleep 100000h
