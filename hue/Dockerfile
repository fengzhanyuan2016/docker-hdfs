FROM gethue/hue:latest

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update

RUN apt-get install -qy curl vim

WORKDIR /usr/share/hue

COPY hue.ini ./desktop/conf/hue.ini
# hdfs://localhost:8020
EXPOSE 8888

CMD ["./startup.sh"]
