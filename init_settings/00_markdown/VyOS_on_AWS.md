AWSインスタンスにVyOSを立ててリモートから操作する手順書
（created 2021/06/22 last modified 2023/12/11）

EC2インスタンスの作成（初回・構築時のみ）

AWSにログイン
・Gmailを開き、右上のGoogleアプリアイコン→「AWS for APC」を押下

EC2画面に移動
・上部の検索窓で、EC2 を検索しサービス配下の 「EC2」 を押下
・左メニュー 「インスタンス」 を押下し、 右上の「インスタンスの起動」を押下

起動するインスタンスの情報を入力
名前：APCのユーザ名(メールアドレスの@前)を入力
インスタンスタイプ：「t2.micro」→「t2.small」に変更
キーペア(ログイン)
・キーペア名：APCのユーザ名
・「キーペアを作成」を押下、キーペアがダウンロードされる
ネットワーク設定
・「編集」を押下
・パブリックIPの自動割り当て「無効化」→「有効化」
・セキュリティグループ名：APCのユーザ名
・インバウンドセキュリティグループのルール
　・タイプ：「ssh」→「すべてのトラフィック」
　・ソースタイプ：「任意の場所」→「自分のIP」
右下の「インスタンスを起動」を押下
・インスタンスが正常に起動（緑色のバー）になることを確認

起動したインスタンス情報の確認
・出力したインスタンスID（ i- から始まるID）を押下
・パブリックIPv4アドレスをコピー

起動したインスタンスにSSH(TeraTerm推奨)
ホスト：1.4.でコピーしたパブリックIPv4アドレス
ユーザ名：ec2-user
パスワード：空欄
1.3.3.でダウンロードした鍵のパスを指定

トレーニング環境の構築（初回・構築時のみ）

gitをインストール
sudo dnf install -y git

githubから資材を配置しているリポジトリをclone
git clone <https://github.com/apc-nw-auto-cft/ansible_on_vyos.git>

シェルスクリプトを実行して、dockerとpoetryをインストール
cd ~/ansible_on_vyos
sh ./init.sh

再度SSHでログインをし直す（TeraTermだと、altキー+D ）

sudo なしでdockerコマンドを打てることを確認(errorにならなければOK)
docker ps

poetryでpython packageをinstall
cd ~/ansible_on_vyos
poetry install

poetry環境ログイン
poetry shell
promptに(XXXX)が付いたことを確認

ansible-navigaterのイメージをpull
docker pull ghcr.io/apc-nw-auto-cft/ansible_on_vyos/ee:0.2

dockerコンテナの作成、起動
docker-compose -f docker-compose.yml up -d

test用のplaybookを実行
ansible-navigator run test.yml

トレーニング時に毎回行うこと

構築したEC2インスタンスを起動

起動したインスタンスにSSH(VSCode推奨)
・VSCodeを起動
・左下にある「><」のような緑色のマークをクリック
・SSH構成ファイルを開く→C:\Users\<ユーザ名>\.ssh\
・先頭に半角スペース2つあけて以下をコピーして、1行目~4行目に貼付する
  Host
  HostName
  User
  IdentityFile
・各項目半角スペース1つあけて、続けて情報を以下のように入力する。
  
  Host yokogushi_EC2　#EC2に接続するときに分かりやすい名前で
  HostName xx.xx.xx.xx #パブリックIPv4アドレス(毎回変わるので注意)
  User ec2-user
  IdentityFile C:\Users\sh_sasaki_ap-com\Downloads\xxx.pem
   #ダウンロードした鍵のパス

6. Ctrl + S で上記を保存する
7. 左下にある「><」のような緑色のマークをクリック
8. ホストに接続する→上記のHostで記載したHost名
9. Linux→続行 を選択
10. AWSで作成したEC2インスタンスに接続完了
11. 表示→ターミナル でコマンドを実行可能
