
# day8 総合演習

- 以下の構成図を見て、各問いに答えてください。
![image](https://github.com/apc-nw-auto-cft/ansible_on_vyos/blob/main/others/general-practice1.png)

## 問題

### 前提条件

- 使用インベントリファイル：「/home/ec2-user/ansible_on_vyos/ansible_practice/08_general-practice」配下のinventory.ini
- playbook作成先ディレクトリ：「/home/ec2-user/ansible_on_vyos/ansible_practice/08_general-practice」配下
- playbook名：自由

### 目的

- 現在host01→host02に通信をするとき、vyos01を経由する。playbookでこれをvyos02を経由することに変更したい。

<br>

1. 以下のplaybookを作成してください。
<br> ※playbookを実行する前後で、**traceroute**を実行して通信経路が変化していることを確認すること。

- 内容：
  - １. vyos01のvrrpのプライオリティ値を150→50に変更する。
  - ２. vyos01/vyos02の事前・事後で、「show vrrp」を実行する。
  - ３. 1-2で確認した事前・事後確認内容は実行結果に出力させる。

<br>

### 目的

- vyos01のvrrpのプライオリティ値を変更する際に、ディレクトリ作成・ファイル出力・メッセージ出力をする。

2-1. 以下のplaybookを作成してください。

- 内容：
  - １. localhostの「/home/ec2-user/ansible_on_vyos/ansible_practice/08_general-practice」配下に、  
        「/before/vyos01」 「/before/vyos02」「/after/vyos01」「/after/vyos02」のディレクトリを作成する(※loopディレクティブを使用すること)
  - ２. パーミッションは「0755」で作成する
  - ３. hosts: localhost で作成すること。

<br>

2-2. 以下のplaybookを作成してください。

- 内容：
  - １. vyos01/vyos02でshowコマンドを実行する。
  - ２. 2-2-1で確認した実行結果を、「/before/vyos01」 「/before/vyos02」にそれぞれテキストファイルで出力させる。（ファイル名は自由）
  - ３. vyos01/vyos02の設定を変更する何らかのコマンドを実行する。（実行コマンドは何でも・何個でも可。例．vrrp priority、description）
  - ４．設定後も同様に、事後のshowコマンドを実行→「/after/vyos01」 「/after/vyos02」にそれぞれファイル出力させる。

<br>

2-3. 以下のplaybookを作成してください。

- 内容：
  - １. vyos01のvrrpのプライオリティ値を任意の値に変更する。その際、異常値が入力されてもplaybookがfailしないようにする。
  - ２. 2-3-1のタスクが成功したときに"succeeded"のメッセージを出力する。
  - ３. 2-3-1のタスクが失敗したときに"failed"のメッセージを出力する。
  - ４. 2-3-1のvrrp priority値が正常な場合と異常な場合に、2-3-2,2-3-3で  
  想定通りのmessageが表示されることを確認する。なお、vrrp priorityの正常値は1-255の範囲。

<br>

### ヒント

- すべて講座で習った範囲で上記のplaybookを作成することができます
- 講座で習っていない内容をplaybookに組み込むことも可能です
- ブログもよいですが、最終的には同様の内容が書かれている公式のAnsibleドキュメントと照らし合わせながら調べることをお勧めします。
- 不明点などはslackでご連絡いただければ助かります。

<br>

### 総合演習の解説日とそれまでについて

- 解説日：6月20日(木) 当日は発表(playbookの紹介)もしていただきたいと考えています
- 解説日まで：演習を進めていただければと思います。日にちがいつもより開くので、進捗確認を適宜行わせていただきますのでその際は解答お願いいたします。
