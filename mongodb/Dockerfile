FROM ubuntu:trusty
LABEL app=mongodb

RUN [ -d /packages ] || mkdir /packages
RUN mkdir /data
VOLUME /data

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list.trusty /etc/apt/sources.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt-get update
RUN apt-get install -y mongodb-org curl graphicsmagick
RUN apt-get install -y nodejs npm build-essential
RUN apt-get install -y openssh-server openssh-client

RUN mkdir ~/.ssh && chmod 700 ~/.ssh
RUN ssh-keygen -t rsa -N "" -P "" -f ~/.ssh/id_rsa
RUN cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys

RUN echo '\nreplication:\n  replSetName: "001-rs"' | cat >> /etc/mongod.conf
RUN sed -i -- 's/dbPath:.*$/dbPath: \/data\/mongodb/g' /etc/mongod.conf
RUN sed -i -- 's/bindIp:.*$/bindIp: 0.0.0.0/g' /etc/mongod.conf
RUN [ -d /data/mongodb ] || mkdir /data/mongodb
RUN echo '#!/bin/bash\n\nnohup mongod --config /etc/mongod.conf >> /data/mongodb/stdout 2>&1 &' | cat >> /packages/start_mongo.sh
RUN chmod +x /packages/start_mongo.sh
COPY rs_init.sh /packages/
RUN chmod +x /packages/rs_init.sh

EXPOSE 3000 22

ENTRYPOINT service ssh start && ([ -d /data/mongodb ] || mkdir /data/mongodb) && /packages/start_mongo.sh && (/packages/rs_init.sh || true) && (/packages/rs_init.sh || true) && /bin/bash
CMD ["true"]
