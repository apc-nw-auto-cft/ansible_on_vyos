#!/bin/bash

# check if "ansible_onv_vyos" exists

if [ ! -d  ~/ansible_on_vyos ]
then
  echo "the directory of ansible_on_vyos dose not exists"
  exit 1
fi

# uninstall old docker and install new docker
printf "password: "
read password

# docker uninstall
#初期状態でインストールされているのは、"docker"と"wmdocker"のみ。
#dockerとwmdockerを削除する。
for pkg in docker wmdocker;
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
#/etc/apt/sources.list.d/(755 root root)内にファイルを書き込むため、root権限で実行する必要がある。
#末尾の"password"は不要か？
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo -S tee /etc/apt/sources.list.d/docker.list > /dev/null


# install poetry
curl -sSL https://install.python-poetry.org | python3 -

#環境変数を親シェルに適用するために、source(.)コマンドでスクリプトを実行する必要がある。
#さらに毎回PATHを通すためには、init_settings/dotfiles/.bashrcか~/.bashrcファイルにexportコマンドを書き込む。

path_to_add="/home/ubuntu/.local/bin"

#$path_to_addを展開するために""で囲み、$PATHは展開しないのでエスケープする。
if ! [[ $PATH == *$path_to_add* ]]; then
  export PATH="$path_to_add:$PATH"
  echo "export PATH=$path_to_add:\$PATH" >> ~/.bashrc;
fi

poetry config virtualenvs.in-project true

# install python pkgs by poetry
poetry install -C ~/ansible_on_vyos/
