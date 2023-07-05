#!/bin/bash

# read password
printf "password: "
read password

# docker uninstall
echo "### remove old docker ###"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc;
do echo "$password" | sudo -S apt remove $pkg;
done

# docker gpg etc,,,
echo "### apt install ###"
echo "$password" | sudo -S apt update -y
echo "$password" | sudo -S apt install -y  ca-certificates curl gnupg


echo "### manage gpg ###"

echo "$password" | sudo -S install -m 0755 -d /etc/apt/keyrings
wget --trust-server-names https://download.docker.com/linux/ubuntu/gpg -O docker.gpg
echo "$password" | sudo -S gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg docker.gpg
rm docker.gpg

echo "$password" | sudo -S chmod a+r /etc/apt/keyrings/docker.gpg

echo "### set up the repository ###"

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

curl -sSL https://install.python-poetry.org | python3 -

path_to_add="/home/ubuntu/.local/bin"

if ! [[ $PATH == *$path_to_add* ]]; then
  export PATH="$path_to_add:$PATH"
  echo 'export PATH="$path_to_add:$PATH"' >> .bashrc;
fi

poetry config virtualenvs.in-project true
poetry install -C ~/ansible_on_vyos/
