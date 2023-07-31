FROM docker.io/ubuntu:jammy-20230624

RUN groupadd firefox && \
  useradd --create-home --gid firefox firefox && \
  chown --recursive firefox:firefox /home/firefox/

RUN DEBIAN_FRONTEND=noninteractive apt update && \
  apt upgrade -y && \
  apt install -y dumb-init socat fontconfig software-properties-common

RUN add-apt-repository ppa:mozillateam/ppa

RUN echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' > /etc/apt/preferences.d/firefox

RUN DEBIAN_FRONTEND=noninteractive apt update && \
  apt install -y firefox && \
  rm -rf /var/lib/apt/lists/*

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

EXPOSE 2828

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
