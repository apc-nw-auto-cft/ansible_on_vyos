FROM ubuntu:22.04
RUN apt update -y && apt install -y \ 
    net-tools \
    openssh-server \
    traceroute \
 && apt clean all \
 && rm -rf /var/cache/apt/*

RUN rm -f /etc/ssh/sshd_config
COPY sshd_config /etc/ssh/
EXPOSE 22
RUN echo "root:test_password" | chpasswd
