FROM ubuntu

RUN apt-get update && \
 apt-get install -y openssh-server

RUN mkdir -p -m0755 /var/run/sshd
COPY remote-key.pub /root/.ssh/authorized_keys

RUN apt install -y  mysql-server && \
    apt install -y curl && \
    apt install -y zip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install
CMD /usr/sbin/sshd -D
