#!/bin/bash

# install poetry
curl -sSL https://install.python-poetry.org | python3 -

poetry config virtualenvs.in-project true

# install python pkgs by poetry
poetry install --no-root -C ~/ansible_on_vyos/

poetry shell

sudo dnf install -y docker
