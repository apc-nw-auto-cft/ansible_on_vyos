
# ansible-navigatorのはなし

- 目次
  - Playbookを実行する方法は？
  - ansible-navigatorとは？
  - ansible-playbookからansible-navigatorへ移行した経緯
  - ansible-navigator構成図
  - 参考サイト

<br>
<br>
<br>

---

## Playbookを実行する方法は？
Playbookを実行する方法は何種類か方法はあるが、昔から定番だった方法は以下である。
```shell
ansible-playbook -i <インベントリファイル> <Playbook名>.yml 
```

但し、本トレーニングでは以下のコマンドでPlaybookを実行する。
```shell
ansible-navigator run <Playbook名>.yml -i <インベントリファイル>
```
ansible-playbookではなく、ansible-navigatorになった経緯についても簡単に述べる。

## ansible-navigatorとは？
ansible-navigatorは、Execution Environment（EE）経由でPlaybookを実行するコマンド。

- Execution Environment（以下EE）とは
  - Ansibleを実行するために必要なものが入っているコンテナ化したイメージ。

## ansible-playbookからansible-navigatorへ移行した経緯

- ansible-playbookコマンド期1
  - ansibleを実行するサーバの環境によって動いたり動かなかったりなどの問題が発生していた。
  - ex) ansibleのバージョン差分、pythonパッケージの有無など。

- ansible-playbookコマンド期2
  - 上記の問題を解消するため、実行環境をコンテナ化したイメージ(EE)にする。
  - podmanやdockerなどのコンテナツール経由でEE内でansible-playbookを実行していた。

- ansible-navigatorの登場
  - 2021年6月、ansible-navigatorがリリースされる。
  - ansible-navigatorコマンドはEE経由でPlaybookを実行することが可能なツール
  - podmanやdocker経由でPlaybookを実行していた時よりも利便性が向上
  - ex) 設定ファイル(ansible-navigator.yaml)にオプションを記載していれば、オプション指定が不要など。

- ansible-builderの登場
  - ansible-navigatorと同時期にansible-builderがリリースされる。
  - ansible-builderは、ansible-navigatorが利用するEEを作成するツール。
  - ansible-builderでEEを作成し、それをansible-navigatorが利用する。

## ansible-navigator構成図
今回のトレーニングの構成図は以下となる。<br>
![image](https://github.com/apc-nw-auto-cft/ansible_on_vyos/blob/50-ansible-navigator%E3%81%AE%E8%B3%87%E6%96%99%E4%BD%9C%E6%88%90/others/navigator_image.png?raw=true)

## 参考サイト
  - [これからはじめるAnsible - Ansible Night Tokyo 2024](https://www.slideshare.net/slideshow/ansible-ansible-night-tokyo-2024/266763151)
  - [2021年頃からコンテナ化が進んできたAnsible実行環境](https://logmi.jp/tech/articles/329608)
 
