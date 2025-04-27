#----------------------
#        base
#----------------------
FROM redhat/ubi9-init AS baseimage
# allow subscription-manager in docker
ENV SMDEV_CONTAINER_OFF=1 
RUN --mount=type=secret,id=REDHAT_USERNAME --mount=type=secret,id=REDHAT_PASSWORD export REDHAT_USERNAME=$(cat /run/secrets/REDHAT_USERNAME) && \
    export REDHAT_PASSWORD=$(cat /run/secrets/REDHAT_PASSWORD) && \
    subscription-manager register --username $REDHAT_USERNAME --password $REDHAT_PASSWORD --auto-attach && \
    subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms && \
    dnf install -y sudo cronie hostname vim procps glibc-langpack-en net-tools iproute iputils nmap-ncat wget openssh-server ansible-core firewalld \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf clean all -y && \
    subscription-manager unregister && \
    sed -i '110s/^#//' /etc/sudoers

RUN systemctl enable sshd && \
    ssh-keygen -A && ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519 -N "" && \
    cp /root/.ssh/id_ed25519.pub /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && \
    echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" > /root/.ssh/config

RUN mkdir -p /etc/ansible/playbooks
WORKDIR /etc/ansible/playbooks
ENV LANG=en_US.UTF-8
ENV LC_TIME=en_US.UTF-8
ENV TZ=Asia/Taipei
