#!/bin/bash

# uninstall old docker and install new docker
printf "password: "
read password

# docker uninstall
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc;
do echo "$password" | sudo -S apt remove $pkg;
done

# install docker gpg etc,,,
echo "$password" | sudo -S apt update -y
echo "$password" | sudo -S apt install -y  ca-certificates curl gnupg


# manage gpg
echo "$password" | sudo -S install -m 0755 -d /etc/apt/keyrings
wget --trust-server-names https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
echo "$password" | sudo -S gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg docker.gpg
echo "$password" | sudo -S chmod a+r /etc/apt/keyrings/docker.gpg
rm docker.gpg

# set up repo
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# install poetry
curl -sSL https://install.python-poetry.org | python3 -

path_to_add="/home/ubuntu/.local/bin"

if ! [[ $PATH == *$path_to_add* ]]; then
  export PATH="$path_to_add:$PATH"
  echo 'export PATH="$path_to_add:$PATH"' >> .bashrc;
fi

poetry config virtualenvs.in-project true

# install python pkgs by poetry
poetry install -C ~/ansible_on_vyos/
