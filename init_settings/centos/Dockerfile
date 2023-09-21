From centos:7
Run yum update -y && yum install -y \ 
    epel-release \
    net-tools \
    openssh-clients \
    openssh-server \
    traceroute \
 && yum clean all \
 && rm -rf /var/cache/yum/*
#編集内容で上書きするには―iオプションが必要。    
Run sed -i -e 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:test_password" | chpasswd