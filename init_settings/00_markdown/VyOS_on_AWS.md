
# AWSインスタンスにVyOSを立ててリモートから操作する手順書

**created 2021/06/22**  
**last modified 2023/12/11**

- [1. 前提条件](#1-前提条件)
- [2. EC2インスタンスの作成（初回構築時のみ）](#2-ec2インスタンスの作成初回構築時のみ)
  - [2.1. AWSにログイン](#21-awsにログイン)
  - [2.2. EC2画面に移動](#22-ec2画面に移動)
  - [2.3. 起動するインスタンスの情報を入力](#23-起動するインスタンスの情報を入力)
  - [2.4. 起動したインスタンス情報の確認](#24-起動したインスタンス情報の確認)
  - [2.5. 起動したインスタンスにSSH](#25-起動したインスタンスにssh)
- [3. トレーニング環境の構築（初回構築時のみ）](#3-トレーニング環境の構築初回構築時のみ)
  - [3.1. gitをインストール](#31-gitをインストール)
  - [3.2. githubから資材を配置しているリポジトリをclone](#32-githubから資材を配置しているリポジトリをclone)
  - [3.3. シェルスクリプトを実行して、dockerとpoetryをインストール](#33-シェルスクリプトを実行してdockerとpoetryをインストール)
  - [3.4. 再度SSHでログインをし直す（TeraTermだと、altキー+D ）](#34-再度sshでログインをし直すteratermだとaltキーd-)
  - [3.5. sudo なしでdockerコマンドを打てることを確認(errorにならなければOK)](#35-sudo-なしでdockerコマンドを打てることを確認errorにならなければok)
  - [3.6. poetryでpython packageをinstall](#36-poetryでpython-packageをinstall)
  - [3.7. poetry環境ログイン](#37-poetry環境ログイン)
  - [3.8. ansible-navigaterのイメージをpull](#38-ansible-navigaterのイメージをpull)
  - [3.9. dockerコンテナの作成、起動](#39-dockerコンテナの作成起動)
  - [3.10. test用のplaybookを実行](#310-test用のplaybookを実行)
- [4. トレーニング時に毎回行うこと](#4-トレーニング時に毎回行うこと)
  - [4.1. 構築したEC2インスタンスを起動](#41-構築したec2インスタンスを起動)
  - [4.2. 起動したインスタンスにSSH(VSCode推奨)](#42-起動したインスタンスにsshvscode推奨)

## 1. 前提条件

- [Google Chrome](https://www.google.com/intl/ja_jp/chrome/dr/download/?brand=SLLM&ds_kid=43700078506124150&gad_source=1&gclid=Cj0KCQiAxOauBhCaARIsAEbUSQRk28ozdTRkvBmWD9Q6zIj_V6F_dLB-xNAdA7ZI8ceK0t2wRo26QI0aAhQeEALw_wcB&gclsrc=aw.ds)(以降Chrome)がインストールされていること
- Microsoft [Visual Studio Code](https://code.visualstudio.com/download)(以降VScode)がインストールされていること
- rsa-sha2対応のリモートログオンクライアントがインストールされていること
  - [Tera Term](https://forest.watch.impress.co.jp/library/software/utf8teraterm/)の場合は[v4.107以降](<https://forest.watch.impress.co.jp/docs/news/1539268.html>)

## 2. EC2インスタンスの作成（初回構築時のみ）

### 2.1. AWSにログイン

- Chromeを開き、右上のGoogleアプリアイコン→「AWS for APC」を押下

### 2.2. EC2画面に移動

- 上部の検索窓で、EC2 を検索しサービス配下の 「EC2」 を押下
- 左メニュー 「インスタンス」 を押下し、 右上の「インスタンスを起動」を押下

### 2.3. 起動するインスタンスの情報を入力

- 名前とタグ
  - 「名前」にAPCのユーザ名(メールアドレスの@前)を入力  
  - 「さらにタグを追加」を押下
  - 「新規タグを追加」を押下
  - 「キー」に任意の値を入力(例：please)
  - 「値」に「do_not_stop」を入力

- アプリケーションおよび OS イメージ (Amazon マシンイメージ)
  - 「クイックスタート」から「Amazon Linux」を選択

- インスタンスタイプ
  - 「インスタンスタイプ」から「t2.small」を選択  

- キーペア(ログイン)  
  - 「新しいキーペアの作成」を押下
  - 「キーペア名」にAPCのユーザ名(メールアドレスの@前)を入力
  - 「キーペアを作成」を押下、キーペアがダウンロードされる

- ネットワーク設定
  - 「編集」を押下
  - 「パブリックIPの自動割り当て」にて「有効化」を選択
  - 「セキュリティグループ名」にAPCのユーザ名(メールアドレスの@前)を入力
  - 「インバウンドセキュリティグループのルール」について以下の通り設定
    - 「タイプ」にて「すべてのトラフィック」を選択
    - 「ソースタイプ」にて「自分のIP」を選択

右下の「インスタンスを起動」を押下  

インスタンスが正常に起動（緑色のバー）になることを確認  

### 2.4. 起動したインスタンス情報の確認

- 出力したインスタンスID（ i- から始まるID）を押下
- 「パブリックIPv4アドレス」に表示されるIPアドレスをコピー

### 2.5. 起動したインスタンスにSSH

**※Tera Termを利用している場合の手順として記載**

「TCP/IP」のウィンドウで以下の通り操作

- 「ホスト」に2.4.でコピーしたパブリックIPv4アドレスを入力
- 「サービス」にて「SSH」を指定
- 「TCPポート」にて「22」を入力
- 「SSHバージョン」にて「SSH2」を指定

「OK」を押下  
(「セキュリティ警告」のウィンドウが表示された場合は「続行」を押下)

「SSH認証」のウィンドウで以下の通り操作

- 「ユーザ名」にて「ec2-user」を入力
- 「認証方式」にて「RSA/DSA/ECDSA/ED25519鍵を使う」を選択
- 「秘密鍵」にて2.3.でダウンロードした鍵のフォルダパスを指定

「OK」を押下  
以下のようなイメージでプロンプトが返ってくることを確認する

```shell
[ec2-user@ip-172-31-38-211 ~]$
```

## 3. トレーニング環境の構築（初回構築時のみ）

### 3.1. gitをインストール

```shell
sudo dnf install -y git
```

### 3.2. githubから資材を配置しているリポジトリをclone

```shell
git clone <https://github.com/apc-nw-auto-cft/ansible_on_vyos.git>
```

### 3.3. シェルスクリプトを実行して、dockerとpoetryをインストール

```shell
cd ~/ansible_on_vyos
sh ./init.sh
```

### 3.4. 再度SSHでログインをし直す（TeraTermだと、altキー+D ）

### 3.5. sudo なしでdockerコマンドを打てることを確認(errorにならなければOK)

```shell
docker ps
```

### 3.6. poetryでpython packageをinstall

```shell
cd ~/ansible_on_vyos

poetry install
```

### 3.7. poetry環境ログイン

```shell
poetry shell

# promptに(XXXX)が付いたことを確認
```

### 3.8. ansible-navigaterのイメージをpull

```shell
docker pull ghcr.io/apc-nw-auto-cft/ansible_on_vyos/ee:0.2
```

### 3.9. dockerコンテナの作成、起動

```shell
docker-compose -f docker-compose.yml up -d
```

### 3.10. test用のplaybookを実行

```shell
ansible-navigator run test.yml
```

## 4. トレーニング時に毎回行うこと

### 4.1. 構築したEC2インスタンスを起動

### 4.2. 起動したインスタンスにSSH(VSCode推奨)

- VSCodeを起動
- 左下にある「><」のような緑色のマークをクリック
- SSH構成ファイルを開く→C:\Users\<ユーザ名>\.ssh\
- 先頭に半角スペース2つあけて以下をコピーして、1行目~4行目に貼付する  
  Host  
  HostName  
  User  
  IdentityFile  
- 各項目半角スペース1つあけて、続けて情報を以下のように入力する。  

```yaml
Host yokogushi_EC2　#EC2に接続するときに分かりやすい名前で  
  HostName xx.xx.xx.xx #パブリックIPv4アドレス(毎回変わるので注意)  
  User ec2-user  
  IdentityFile C:\Users\sh_sasaki_ap-com\Downloads\xxx.pem  
   #ダウンロードした鍵のパス  
```

- Ctrl + S で上記を保存する
- 左下にある「><」のような緑色のマークをクリック
- ホストに接続する→上記のHostで記載したHost名
- Linux→続行 を選択
- AWSで作成したEC2インスタンスに接続完了
- 表示→ターミナル でコマンドを実行可能
