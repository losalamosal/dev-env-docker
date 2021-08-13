FROM debian:buster-slim

RUN adduser --home /home/devboy --no-create-home devboy \
    && usermod -aG sudo devboy \
    && mkdir /home/devboy \
    && chown devboy /home/devboy \
    && chgrp devboy /home/devboy

# Had to update certificates--git https clone was failing
RUN apt-get update \
    && apt-get -y install --no-install-recommends bash zsh unzip curl git ssh openssh-client ca-certificates \
    && update-ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

USER devboy
WORKDIR /home/devboy
RUN zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ||true

# All clones into the container must be public, so HTTPS is best
RUN git clone https://gist.github.com/a662f0204a310631750906edd4bd2146.git zshrc \
    && mv ./zshrc/.zshrc . \
    && rm -rf zshrc
RUN git clone https://github.com/losalamosal/cy-max.git
