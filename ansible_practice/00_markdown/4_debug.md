
# day4 debugモジュール

- debugモジュールを学習する

- 目次
  - 1.debugモジュールとは？
  - 2.debugモジュールの使用例
  - 3.debugモジュールの実習[ハンズオン]
  - debugモジュールについてのまとめ
  - 4.debugモジュールの演習問題

<br>
<br>
<br>

---

## 1.debugモジュールとは？

| モジュール名 | 説明 |
| :-----: | :------------------------------------------------------------------------------------------------------------ |
| debug | playbookの実行結果画面に、任意の文字列や、変数に格納された値を出力することができる。 |

### debugのパラメータ

| パラメータ | 説明  |
| :----- | :----- |
| msg  | 記載した文字列を表示する。<br>"{{ 変数名 }}" とすると、変数の中身を表示する。<br>省略するとデフォルトの"Hello world!"が出力される。 |
| var  | 変数の中身を表示する。 |

- debugモジュールのAnsible documentは[こちら](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html)

<br>
<br>
<br>

---

## 2.debugモジュールの使用例

### パラメータ「msg」の使用例

- 以下は、vyos01に対してvar1に格納された文字列と、msgに記載した文字列を出力しているplaybookである。

```yaml
---
- name: Sample
  hosts: vyos01
  gather_facts: false

  vars:
    var1: This is Test Message

  tasks:
    - name: Debug msg
      ansible.builtin.debug:
        msg: "みなさん {{ var1 }} ですよ。"
```

- 上記のように記述すれば、以下のような実行例として出力ができる。

```
PLAY [Sample] *****************************************************************************

TASK [Debug messages] *****************************************************************************
ok: [vyos01] => {
  "msg": "みなさん This is Test Message ですよ。"
}

PLAY RECAP *************************************************************************************************
vyos01                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

### パラメータ「var」の使用例

- 以下は、vyos01に対してvar1に格納された文字列を出力しているplaybookである。

```yaml
---
- name: Sample
  hosts: vyos01
  gather_facts: false

  vars:
    var1: This is Test Message

  tasks:
    - name: Debug messages
      ansible.builtin.debug:
        var: var1
```

- 上記のように記述すれば、以下のような実行例として出力ができる。
- var1の中身はみれるが、パラメータ「msg」のようにvar1の前後に適当な文字列をつけることはできない。

```
PLAY [Sample] ***************************************************************************

TASK [Debug messages] ***************************************************************************
ok: [vyos01] => {
    "var1": "This is Test Message"
}

PLAY RECAP *************************************************************************************************
vyos01                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

### debugモジュールのデフォルトメッセージ

- 以下は、vyos01に対してデフォルトメッセージを出力しているplaybookである。
- debugモジュールに何のパラメータも指定しないと、デフォルトメッセージが出力される。

```yaml
---
- name: Sample
  hosts: vyos01
  gather_facts: false

  vars:
    var1: This is Test Message

  tasks:
    - name: Debug messages
      ansible.builtin.debug:
```

- 上記のように記述すれば、以下のようにデフォルトメッセージ「Hello world!」が表示されます。

```
PLAY [Sample] ***************************************************************************

TASK [Debug messages] ***************************************************************************
ok: [vyos01] => {
   "msg": "Hello world!"
}

PLAY RECAP *************************************************************************************************
vyos01                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

### debugモジュールと「register」を併用

- register は実行結果を格納することができる
- debugモジュールとregisterを使用して、格納した実行結果を出力することができる
- 以下は、vyos01に対して「show interfaces」「shoe ip route」を実行し、  
  playbook実行結果にvyos01の「show interfaces」「show ip route」
  の内容を出力しているplaybookである。

```yaml
---
- name: Sample
  hosts: vyos01
  gather_facts: false

  tasks:
    - name: Get vyos_command
      vyos.vyos.vyos_command:
        commands:
          - show interfaces
          - show ip route
      register: vyos01_show_command

    - name: Debug vyos_show_command
      ansible.builtin.debug:
        var: vyos01_show_command

```

- 実行すると、以下のような実行結果が出力される。

```
$ ansible-navigator run debug_test.yml -i inventory.ini

PLAY [Sample] *************************************************************************************************

TASK [Get vyos_command] ***************************************************************************************
ok: [vyos01]

TASK [Debug vyos_show_command] ********************************************************************************
ok: [vyos01] => {
    "vyos01_show_command": {
        "changed": false,
        "failed": false,
        "stdout": [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down\nInterface        IP Address                        S/L  Description\n---------        ----------                        ---  -----------\neth0             10.0.0.2/24                       u/u  \neth1             192.168.1.252/24                  u/u  vyos_config-test1\n                 192.168.1.254/24                       \neth2             192.168.2.252/24                  u/u  vyos_config-test2\n                 192.168.2.254/24                       \nlo               127.0.0.1/8                       u/u",
            "Codes: K - kernel route, C - connected, S - static, R - RIP,\n       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,\n       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,\n       F - PBR, f - OpenFabric,\n       > - selected route, * - FIB route, q - queued, r - rejected, b - backup\n\nK>* 0.0.0.0/0 [0/0] via 10.0.0.1, eth0, 00:20:44\nC>* 10.0.0.0/24 is directly connected, eth0, 00:20:44\nC * 192.168.1.0/24 is directly connected, eth1, 00:20:31\nC>* 192.168.1.0/24 is directly connected, eth1, 00:20:44\nC * 192.168.2.0/24 is directly connected, eth2, 00:20:31\nC>* 192.168.2.0/24 is directly connected, eth2, 00:20:44"
        ],
        "stdout_lines": [
            [
                "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
                "Interface        IP Address                        S/L  Description",
                "---------        ----------                        ---  -----------",
                "eth0             10.0.0.2/24                       u/u  ",
                "eth1             192.168.1.252/24                  u/u  vyos_config-test1",
                "                 192.168.1.254/24                       ",
                "eth2             192.168.2.252/24                  u/u  vyos_config-test2",
                "                 192.168.2.254/24                       ",
                "lo               127.0.0.1/8                       u/u"
            ],
            [
                "Codes: K - kernel route, C - connected, S - static, R - RIP,",
                "       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,",
                "       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,",
                "       F - PBR, f - OpenFabric,",
                "       > - selected route, * - FIB route, q - queued, r - rejected, b - backup",
                "",
                "K>* 0.0.0.0/0 [0/0] via 10.0.0.1, eth0, 00:20:44",
                "C>* 10.0.0.0/24 is directly connected, eth0, 00:20:44",
                "C * 192.168.1.0/24 is directly connected, eth1, 00:20:31",
                "C>* 192.168.1.0/24 is directly connected, eth1, 00:20:44",
                "C * 192.168.2.0/24 is directly connected, eth2, 00:20:31",
                "C>* 192.168.2.0/24 is directly connected, eth2, 00:20:44"
            ]
        ]
    }
}

PLAY RECAP ****************************************************************************************************
vyos01                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

### 「register」内に保存されている情報

- 上記のように、registerの内容を変数に保存すると、stdoutとstdout_linesの2つのデータ形式が保存される
- ターミナルに出力させる場合に、出力方法が複数あります

|  | 変数名.stdout<br>(stdoutすべて) | 変数名.stdout[0]<br>(stdoutの1つめの要素) | 変数名.stdout_lines<br>(stdout_linesすべて) | 変数名.stdout_lines[0]<br>(stdout_linesの1つめの要素) |
| - | :-: | :-: | :-: | :-: |
| ターミナル出力 | 改行されない | 改行されない | 改行される | 改行される |
| ファイル出力 | 改行されない | 改行される | 改行されない | 改行されない |

#### 変数名.stdout

- 上記playbookを変数名.stdout で実行したplaybookである(一部省略)

```yaml
~~省略~~
    - name: Debug vyos_show_command
      ansible.builtin.debug:
        var: vyos01_show_command.stdout
```

- 実行すると、以下のような実行結果が出力される。
- 「改行されない」ので、一行にすべて出力される。

```
~~省略~~
TASK [Debug vyos_show_command] ********************************************************************************
ok: [vyos01] => {
    "vyos01_show_command.stdout": [
        "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down\nInterface        IP Address                        S/L  Description\n---------        ----------                        ---  -----------\neth0             10.0.0.2/24                       u/u  \neth1             192.168.1.252/24                  u/u  vyos_config-test1\n                 192.168.1.254/24                       \neth2             192.168.2.252/24                  u/u  vyos_config-test2\n                 192.168.2.254/24                       \nlo               127.0.0.1/8                       u/u",
        "Codes: K - kernel route, C - connected, S - static, R - RIP,\n       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,\n       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,\n       F - PBR, f - OpenFabric,\n       > - selected route, * - FIB route, q - queued, r - rejected, b - backup\n\nK>* 0.0.0.0/0 [0/0] via 10.0.0.1, eth0, 01:20:25\nC>* 10.0.0.0/24 is directly connected, eth0, 01:20:25\nC * 192.168.1.0/24 is directly connected, eth1, 01:20:13\nC>* 192.168.1.0/24 is directly connected, eth1, 01:20:25\nC * 192.168.2.0/24 is directly connected, eth2, 01:20:13\nC>* 192.168.2.0/24 is directly connected, eth2, 01:20:25"
    ]
}

PLAY RECAP ****************************************************************************************************
vyos01                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

#### 変数名.stdout[0]

- 上記playbookを変数名.stdout[0] で実行したplaybookである(一部省略)

```yaml
~~省略~~
    - name: Debug vyos_show_command
      ansible.builtin.debug:
        var: vyos01_show_command.stdout[0]
```

- 実行すると、以下のような実行結果が出力される。
- 「改行されない」ので、一行にすべて出力される。
- .stdout の時と違い、[0]となっているので、stdoutの[]内の1つめの要素(show interfaces)が出力される。

```
~~省略~~
TASK [Debug vyos_show_command] ********************************************************************************
ok: [vyos01] => {
    "vyos01_show_command.stdout[0]": "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down\nInterface        IP Address                        S/L  Description\n---------        ----------                        ---  -----------\neth0             10.0.0.2/24                       u/u  \neth1             192.168.1.252/24                  u/u  vyos_config-test1\n                 192.168.1.254/24                       \neth2             192.168.2.252/24                  u/u  vyos_config-test2\n                 192.168.2.254/24                       \nlo               127.0.0.1/8                       u/u"
}

PLAY RECAP ****************************************************************************************************
vyos01                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

#### 変数名.stdout_lines

- 上記playbookを変数名.stdout_lines で実行したplaybookである(一部省略)

```yaml
~~省略~~
    - name: Debug vyos_show_command
      ansible.builtin.debug:
        var: vyos01_show_command.stdout_lines
```

- 実行すると、以下のような実行結果が出力される。
- 「改行される」ので、実際にvyosにログインして実行したときのような結果が出力される

```
~~省略~~
TASK [Debug vyos_show_command] ********************************************************************************
ok: [vyos01] => {
    "vyos01_show_command.stdout_lines": [
        [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
            "Interface        IP Address                        S/L  Description",
            "---------        ----------                        ---  -----------",
            "eth0             10.0.0.2/24                       u/u  ",
            "eth1             192.168.1.252/24                  u/u  vyos_config-test1",
            "                 192.168.1.254/24                       ",
            "eth2             192.168.2.252/24                  u/u  vyos_config-test2",
            "                 192.168.2.254/24                       ",
            "lo               127.0.0.1/8                       u/u"
        ],
        [
            "Codes: K - kernel route, C - connected, S - static, R - RIP,",
            "       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,",
            "       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,",
            "       F - PBR, f - OpenFabric,",
            "       > - selected route, * - FIB route, q - queued, r - rejected, b - backup",
            "",
            "K>* 0.0.0.0/0 [0/0] via 10.0.0.1, eth0, 01:25:35",
            "C>* 10.0.0.0/24 is directly connected, eth0, 01:25:35",
            "C * 192.168.1.0/24 is directly connected, eth1, 01:25:23",
            "C>* 192.168.1.0/24 is directly connected, eth1, 01:25:35",
            "C * 192.168.2.0/24 is directly connected, eth2, 01:25:23",
            "C>* 192.168.2.0/24 is directly connected, eth2, 01:25:35"
        ]
    ]
}

PLAY RECAP ****************************************************************************************************
vyos01                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

#### 変数名.stdout_lines[0]

- 上記playbookを変数名.stdout_lines[0]で実行したplaybookである(一部省略)

```yaml
~~省略~~
    - name: Debug vyos_show_command
      ansible.builtin.debug:
        var: vyos01_show_command.stdout_lines[0]
```

- 実行すると、以下のような実行結果が出力される。
- 「改行される」ので、実際にvyosにログインして実行したときのような結果が出力される
- .stdout_lines の時と違い、[0]となっているので、stdoutの[]内の1つめの要素(show interfaces)が出力される。

```
~~省略~~
TASK [Debug vyos_show_command] ********************************************************************************
ok: [vyos01] => {
    "vyos01_show_command.stdout_lines[0]": [
        "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
        "Interface        IP Address                        S/L  Description",
        "---------        ----------                        ---  -----------",
        "eth0             10.0.0.2/24                       u/u  ",
        "eth1             192.168.1.252/24                  u/u  vyos_config-test1",
        "                 192.168.1.254/24                       ",
        "eth2             192.168.2.252/24                  u/u  vyos_config-test2",
        "                 192.168.2.254/24                       ",
        "lo               127.0.0.1/8                       u/u"
    ]
}

PLAY RECAP ****************************************************************************************************
vyos01                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

<br>
<br>
<br>

---

## 3.debugモジュールの実習[ハンズオン]

### 目的

- localhostに対して、「Hello Ansible!」という文字を表示させる。
- 変数「var1」に「Hello message!」を格納し、localhostに対して「var1」を表示させる。

### 1.ディレクトリ移動

- 使用するplaybook,inventoryファイルが存在するディレクトリに移動

```shell
cd /home/ec2-user/ansible_on_vyos/ansible_practice/04_debug
```

### 2.仮想環境(poetry)に入る

```shell
$ poetry shell

# Spawning shell within /home/ec2-user/ansible_on_vyos/.venv
```

### 3.playbookの内容を確認

```yaml
---
- name: Sample
  hosts: localhost
  gather_facts: false

  vars:
    var1: Hello message!

  tasks:
    - name: Debug msg
      ansible.builtin.debug:
        msg: Hello Ansible!

    - name: Debug var1
      ansible.builtin.debug:
        var: var1
```

### 4.playbookを実行

- localhostにplaybookを実行する場合は、inventoryファイルを指定しなくていい。
  (自分の機器が対象となるため。)

```shell
$ ansible-navigator run debug_module_sample.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Sample] *************************************************************************************************

TASK [Debug msg] **********************************************************************************************
ok: [localhost] => {
    "msg": "Hello Ansible!"
}

TASK [Debug var1] **************************************************************************************
ok: [localhost] => {
    "var1": "Hello message!"
}

PLAY RECAP ****************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

## debugモジュールについてのまとめ

- debugモジュールは、playbookの実行結果画面に、任意の文字列や、変数に格納された値を出力することができる。

- debugモジュールのパラメータは「msg」「var」

- debugモジュールに「register」を併用することで、コマンド実行結果などを出力することができる。

<br>
<br>
<br>

---

## 4.debugモジュールの演習

---

### Q1 以下のplaybookを実行し、出力された実行結果の空欄に当てはまるものは何でしょう

- playbook

```yaml
---
- name: Debug_exercise1
  hosts: localhost
  gather_facts: false

  tasks:
   - name: Debug
     ansible.builtin.debug:
```

- 実行結果

```shell
$ ansible-navigator run debug_module_exam_1.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Exam1] **************************************************************************************************

TASK [Debug] **************************************************************************************************
ok: [localhost] => {
    "msg": ■■■■■■
}

PLAY RECAP ****************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

1. Hello World!
2. "Hello World!"
3. " "
4. "debug"

<br>
<br>
<br>

---

### Q2 以下の条件のplaybookを作成して、実行してください

- playbook作成先ディレクトリ：「/home/ec2-user/ansible_on_vyos/ansible_practice/04_debug」配下
- playbook名：「debug_module_exam_2.yml」で作成
- 実行対象ノード：localhost
- 処理内容：playbook実行結果に、「"msg": "APC"」と出力させる。

<br>
<br>
<br>

---

### Q3 以下の条件のplaybookを作成して、実行してください

- 使用インベントリファイル：「/home/ec2-user/ansible_on_vyos/ansible_practice/04_debug」配下のinventory.ini
- playbook作成先ディレクトリ：「/home/ec2-user/ansible_on_vyos/ansible_practice/04_debug」配下
- playbook名：「debug_module_exam_3.yml」で作成
- 実行対象ノード：vyos02
- 処理内容：
  - 「show interfaces」を実行し、実行結果を出力
  - vyos02のeth1のdescriptionを「debug_exam」に設定
  - description設定後、再度「show interfaces」を実行し結果を出力

<br>
<br>
<br>

---

### A1 正解：「2. "Hello World!"」

- 以下、正しい実行結果

```shell
$ ansible-navigator run debug_module_exam_1.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
not match 'all'

PLAY [Exam1] **************************************************************************************************

TASK [Debug] **************************************************************************************************
ok: [localhost] => {
    "msg": "Hello world!"
}

PLAY RECAP ****************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

<br>
<br>
<br>

---

### A2 以下、解答例

- playbook

```yaml
---
- name: Exam2
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Debug
      ansible.builtin.debug:
        msg: "APC"
```

- playbookの実行結果

```shell
$ ansible-navigator run debug_module_exam_2.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Exam2] **************************************************************************************************

TASK [Debug] **************************************************************************************************
ok: [localhost] => {
    "msg": "APC"
}

PLAY RECAP ****************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```

<br>
<br>
<br>

---

### A3 以下、解答例

- playbook

```yaml
---
- name: Exam3
  hosts: vyos02
  gather_facts: false

  tasks:
    - name: Before show interfaces
      vyos.vyos.vyos_command:
        commands:
          - show interfaces
      register: before_show_interfaces

    - name: Debug before show interfaces
      ansible.builtin.debug:
        var: before_show_interfaces.stdout_lines

    - name: Set description
      vyos.vyos.vyos_config:
        lines:
          - set interfaces ethernet eth1 description debug_exam
        save: true

    - name: After show interfaces
      vyos.vyos.vyos_command:
        commands:
          - show interfaces
      register: after_show_interfaces

    - name: Debug after show interfaces
      ansible.builtin.debug:
        var: after_show_interfaces.stdout_lines
```

- playbookの実行結果

```shell
$ ansible-navigator run debug_module_exam_3.yml -i inventory.ini

PLAY [Exam3] **************************************************************************************************

TASK [Before show interfaces] *********************************************************************************
ok: [vyos02]

TASK [Debug before show interfaces] ***************************************************************************
ok: [vyos02] => {
    "before_show_interfaces.stdout_lines": [
        [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
            "Interface        IP Address                        S/L  Description",
            "---------        ----------                        ---  -----------",
            "eth0             10.0.0.3/24                       u/u  ",
            "eth1             192.168.1.253/24                  u/u  vyos_config-test1",
            "eth2             192.168.2.253/24                  u/u  vyos_config-test2",
            "lo               127.0.0.1/8                       u/u"
        ]
    ]
}

TASK [Set description] ****************************************************************************************
[WARNING]: To ensure idempotency and correct diff the input configuration lines should be similar to how they appear if present in the running configuration on
device
changed: [vyos02]

TASK [After show interfaces] **********************************************************************************
ok: [vyos02]

TASK [Debug after show interfaces] ****************************************************************************
ok: [vyos02] => {
    "after_show_interfaces.stdout_lines": [
        [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
            "Interface        IP Address                        S/L  Description",
            "---------        ----------                        ---  -----------",
            "eth0             10.0.0.3/24                       u/u  ",
            "eth1             192.168.1.253/24                  u/u  debug_exam",
            "eth2             192.168.2.253/24                  u/u  vyos_config-test2",
            "lo               127.0.0.1/8                       u/u"
        ]
    ]
}

PLAY RECAP ****************************************************************************************************
vyos02                     : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

$ 
```
