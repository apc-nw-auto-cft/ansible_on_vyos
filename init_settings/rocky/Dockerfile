From rockylinux:9.2
Run dnf update -y && dnf install -y \ 
    iputils \
    iproute \
    openssh-server \
    traceroute \
 && dnf clean all \
 && rm -rf /var/cache/dnf/*
# 編集内容で上書きするには―iオプションが必要。
Run sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
RUN echo "root:test_password" | chpasswd
