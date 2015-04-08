FROM ubuntu:14.04.2
RUN apt-get update && apt-get upgrade --no-install-recommends -y
RUN apt-get install -y --no-install-recommends inotify-tools
RUN addgroup --gid 1100 rancher && \
    addgroup --gid 1101 docker && \
    useradd -u 1100 -g rancher -G docker,sudo -m -s /bin/bash rancher && \
    echo '## allow password less for rancher user' >> /etc/sudoers && \
    echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
COPY watch-ssh.sh /
ENTRYPOINT ["/watch-ssh.sh"]
