#!/bin/bash

# install docker
sudo dnf install -y docker

# install poetry
curl -sSL https://install.python-poetry.org | python3 -

poetry config virtualenvs.in-project true

# install python pkgs by poetry
poetry install --no-root -C ~/ansible_on_vyos/

# setting ansible-navigator environmental variables
echo 'export ANSIBLE_NAVIGATOR_CONFIG="$HOME/ansible_on_vyos/ansible-navigator.yaml"' >> ~/.bashrc
