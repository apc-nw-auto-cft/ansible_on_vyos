
# day7 loopディレクティブ

- loopディレクティブについて学習する

- 目次
  - 1.loopディレクティブとは？
  - 2.loopディレクティブの説明
  - 3.loopディレクティブの実習(ハンズオン)
  - loopディレクティブのまとめ
  - 4.loopディレクティブの演習問題

<br>
<br>
<br>

---

## 1.loopディレクティブとは？

- loopディレクティブの使用例
  - 同一のタスクを複数回実行
  - 複数の変数やファイルを扱ったりするとき

- 補足
  - loopは、「with_list」で代用することも可能。

- loopのAnsible documentは[こちら](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)

---

## 2.loopディレクティブの説明

- 以下の2つの種類に分けてloopの説明を実施する
  - 標準loop
  - 複数のloop

### 標準loop

- 以下は、loopで「Apple」「Banana」「Peach」を定義し、debug moduleを使用してmsgを出力させているplaybookである。
- loopで繰り返すリストを定義することができる。
- loopで定義した内容は、変数「item」に格納されるようになっている。

```yaml
---
- name: Sample
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Debug fruits
      ansible.builtin.debug:
        msg: "{{ item }}"
      loop:
        - Apple
        - Banana
        - Peach
```

- このplaybookを実行すると、以下のような実行結果となる。
- loopで定義したリストが1つずつ代入され、要素を順番に処理することができる。

```shell
$ ansible-navigator run playbook.yaml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Sample] *********************************************************************************************************************

TASK [Debug fruits] ***************************************************************************************************************
ok: [localhost] => (item=Apple) => {
    "msg": "Apple"
}
ok: [localhost] => (item=Banana) => {
    "msg": "Banana"
}
ok: [localhost] => (item=Peach) => {
    "msg": "Peach"
}

PLAY RECAP ************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### 複数のloop

- 以下は、loopで「fruits: 'Apple', color: 'Red'」「fruits: 'Banana', color: 'Yellow'」「fruits: 'Peach', color: 'Pink'」を定義し、  
debug moduleを使用してmsgを出力させているplaybookである。
- loopを辞書型(Dict型)で定義することができる。
- loopを辞書型(Dict型)で定義したとき、変数「item.fruits」および「item.color」に各値が格納されるようになっている。

```yaml
---
- name: Sample
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Debug fruits
      ansible.builtin.debug:
        msg: "The {{ item.fruits }} is {{ item.color }}"
      loop:
        - { fruits: 'Apple', color: 'Red' }
        - { fruits: 'Banana', color: 'Yellow' }
        - { fruits: 'Peach', color: 'Pink' }
```

- このplaybookを実行すると、以下のような実行結果となる。
- loopで定義した辞書型(Dict型)が1つずつ代入され、要素を順番に処理することができる。

```shell
$ ansible-navigator run playbook.yaml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Sample] *********************************************************************************************************************

TASK [Debug fruits] ***************************************************************************************************************
ok: [localhost] => (item={'fruits': 'Apple', 'color': 'Red'}) => {
    "msg": "The Apple is Red"
}
ok: [localhost] => (item={'fruits': 'Banana', 'color': 'Yellow'}) => {
    "msg": "The Banana is Yellow"
}
ok: [localhost] => (item={'fruits': 'Peach', 'color': 'Pink'}) => {
    "msg": "The Peach is Pink"
}

PLAY RECAP ************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

<br>
<br>
<br>

---

## 3.loopディレクティブの実習

### 目的

- loopディレクティブを使用して、ディレクトリ loop_dir1、loop_dir2を新規作成する

### 1.ディレクトリ移動

- 使用するplaybook,inventoryファイルが存在するディレクトリに移動

```shell
cd /home/ec2-user/ansible_on_vyos/ansible_practice/07_loop
```

### 2.仮想環境(poetry)に入る

```shell
$ poetry shell

# Spawning shell within /home/ec2-user/ansible_on_vyos/.venv
```

### 3.playbookの内容を確認

- varsで変数「dir_names」に「loop_dir1」「loop_dir2」を定義
- loopで変数も指定することができる
- loopで変数「dir_names」を指定させて、file moduleのpathパラメータに代入

```yaml
---
- name: Sample1
  hosts: localhost
  gather_facts: false

  vars:
    dir_names:
      - loop_dir1
      - loop_dir2

  tasks:
    - name: Make directory
      ansible.builtin.file:
        path: /home/ec2-user/ansible_on_vyos/ansible_practice/07_loop/{{ item }}
        state: directory
      loop: "{{ dir_names }}"
```

### 4.playbookを実行

- TASK [make directory] でディレクトリを作成している。  
changed: [localhost] => (item=loop_dir1)および、  
changed: [localhost] => (item=loop_dir2)であることを確認

```shell
$ ansible-navigator run loop_sample_1.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Sample1] ********************************************************************************************************************

TASK [Make directory] *************************************************************************************************************
changed: [localhost] => (item=loop_dir1)
changed: [localhost] => (item=loop_dir2)

PLAY RECAP ************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ 
```

### 5.事後確認

```shell
$ ls -l /home/ec2-user/ansible_on_vyos/ansible_practice/07_loop | grep loop_dir
drwxr-xr-x. 2 ec2-user root       6 Mth d HH:MM loop_dir1
drwxr-xr-x. 2 ec2-user root       6 Mth d HH:MM loop_dir2
$ 
```

<br>
<br>
<br>

---

## loopディレクティブのまとめ

- loopディレクティブは以下のときに使用する
  - 同一のタスクを複数回実行
  - 複数の変数やファイルを扱ったりする
- loopで定義した内容は、変数「item」に格納されるようになっている。
- loopで変数も指定することができる
- リストや辞書型(Dict型)を扱う場合、要素を順番に処理することができる。

<br>
<br>
<br>

---

## 4.loopディレクティブの演習問題

---

### Q1 実行結果から、以下のplaybookの空欄に当てはまるものを考えてください

- playbook

```yaml
---
- name: Exam1
  hosts: localhost
  gather_facts: false

  vars:
    fruits:
      - Apple
      - Banana
      - Peach

  tasks:
    - name: Debug fruits
      ansible.builtin.debug:
        msg: "{{ ■■■ }}"
      loop: "{{ ■■■ }}"
```

- 実行結果

```shell
$ ansible-navigator run loop_exam_1.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Exam1] **********************************************************************************************************************

TASK [Debug fruits] ***************************************************************************************************************
ok: [localhost] => (item=Apple) => {
    "msg": "Apple"
}
ok: [localhost] => (item=Banana) => {
    "msg": "Banana"
}
ok: [localhost] => (item=Peach) => {
    "msg": "Peach"
}

PLAY RECAP ************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ 
```

<br>
<br>
<br>

---

### Q2 出力結果をloopの中から3つだけ出力させたいとき、■■■にはどんな条件式が入るでしょうか

- playbook

```yaml
---
- name: Exam2
  hosts: localhost
  gather_facts: false

  tasks:
    - name: When/loop
      ansible.builtin.debug:
        var: item
      loop:
        - 3
        - 10
        - 25
        - 140
        - 233
        - 350
      when: ■■■
```

<br>
<br>
<br>

---

### Q3 以下の条件のplaybookを作成して、実行してください

- 使用インベントリファイル：「/home/ec2-user/ansible_on_vyos/ansible_practice/07_loop」配下のinventory.ini
- playbook作成先ディレクトリ：「/home/ec2-user/ansible_on_vyos/ansible_practice/07_loop」配下
- playbook名：「loop_exam_3.yml」で作成
- 実行対象ノード：host01、host02
- 処理内容：
  - host01、host02の「/tmp」配下に、「loop_test1.txt」「loop_test2.txt」を作成する(パーミッション等は特に指定なし)

<br>
<br>
<br>

---

### Q4 以下の条件のplaybookを作成して、実行してください

- 使用インベントリファイル：「/home/ec2-user/ansible_on_vyos/ansible_practice/07_loop」配下のinventory.ini
- playbook作成先ディレクトリ：「/home/ec2-user/ansible_on_vyos/ansible_practice/07_loop」配下
- playbook名：「loop_exam_4.yml」で作成
- 実行対象ノード：vyos01、vyos02
- 処理内容：
  - loopディレクティブを使用して、vyos01、vyos02の eth1・eth2にそれぞれdescriptionを設定する
  - eth1→「loop_test1」eth2→「loop_test2」と設定する
  - 事前、事後で「show interfaces」を実施し、実行結果を出力させる（余力があればでOK）

<br>
<br>
<br>

---

### A1 正解：以下、解答例

- playbook

```yaml
---
- name: Exam1
  hosts: localhost
  gather_facts: false

  vars:
    fruits:
      - Apple
      - Banana
      - Peach

  tasks:
    - name: Debug fruits
      ansible.builtin.debug:
        msg: "{{ item }}" #解答
      loop: "{{ fruits }}" #解答
```

<br>
<br>
<br>

---

### A2 正解：以下、解答例

- **item > 26** などでもOK。そのほか解答あれば教えてください。

- playbook

```yaml
---
- name: Exam2
  hosts: localhost
  gather_facts: false

  tasks:
    - name: When/loop
      ansible.builtin.debug:
        var: item
      loop:
        - 3
        - 10
        - 25
        - 140
        - 233
        - 350
      when: item < 26 #解答例
```

- 実行結果

```shell
$ ansible-navigator run answer/loop_exam_2.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Exam2] **********************************************************************************************************************

TASK [When/loop] ******************************************************************************************************************
ok: [localhost] => (item=3) => {
    "ansible_loop_var": "item",
    "item": 3
}
ok: [localhost] => (item=10) => {
    "ansible_loop_var": "item",
    "item": 10
}
ok: [localhost] => (item=25) => {
    "ansible_loop_var": "item",
    "item": 25
}
skipping: [localhost] => (item=140) 
skipping: [localhost] => (item=233) 
skipping: [localhost] => (item=350) 

PLAY RECAP ************************************************************************************************************************
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
  hosts: ubuntu
  gather_facts: false

  tasks:
    - name: Make file
      ansible.builtin.file:
        path: /tmp/{{ item }}
        state: touch
      loop:
        - loop_test1.txt
        - loop_test2.txt
```

- 実行結果

```shell
$ ansible-navigator run loop_exam_3.yml -i inventory.ini

PLAY [Exam3] **********************************************************************************************************************

TASK [Make file] ******************************************************************************************************************
changed: [host01] => (item=loop_test1.txt)
changed: [host02] => (item=loop_test1.txt)
changed: [host01] => (item=loop_test2.txt)
changed: [host02] => (item=loop_test2.txt)

PLAY RECAP ************************************************************************************************************************
host01                     : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
host02                     : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ 
```

- ファイルが作成されているか確認

```shell
$ docker exec -it host01 /bin/bash

# ここからコンテナ(host01)を操作
[root@host01 /]# ls -l /tmp/
total 0
drwx------ 2 root root 37 Mth d HH:MM ansible_yum_payload_Vc17Y3
-rw-r--r-- 1 root root  0 Mth d HH:MM loop_test1.txt
-rw-r--r-- 1 root root  0 Mth d HH:MM loop_test2.txt
-rw-r--r-- 1 root root  0 Mth d HH:MM test_exam4.txt
[root@host01 /]# 
[root@host01 /]# exit
exit

$ docker exec -it host02 /bin/bash

# ここからコンテナ(host02)を操作
[root@host02 /]# ls -l /tmp/
total 0
drwx------ 2 root root 37 Mth d HH:MM ansible_yum_payload_FWE23G
-rw-r--r-- 1 root root  0 Mth d HH:MM loop_test1.txt
-rw-r--r-- 1 root root  0 Mth d HH:MM loop_test2.txt
[root@host02 /]# 
[root@host02 /]# exit
exit

$ 
```

<br>
<br>
<br>

---

### A4 以下、解答例

- playbook

```yaml
---
- name: Exam4
  hosts: vyos
  gather_facts: false

  tasks:
    - name: Check before interface description #任意の実施
      vyos.vyos.vyos_command:
        commands:
          - show interfaces
      register: result

    - name: Check before interface description debug #任意の実施
      ansible.builtin.debug:
        var: result.stdout_lines

    - name: Set descriptions
      vyos.vyos.vyos_config:
        lines:
          - set interfaces ethernet {{ item.ethernet }} description {{ item.description }}
      loop:
        - { ethernet: 'eth1', description: 'loop_test1' }
        - { ethernet: 'eth2', description: 'loop_test2' }

    - name: Check after interface description #任意の実施
      vyos.vyos.vyos_command:
        commands:
          - show interfaces
      register: result

    - name: Check after interface description debug #任意の実施
      ansible.builtin.debug:
        var: result.stdout_lines
```

- 実行結果

```shell
$ ansible-navigator run loop_exam_4.yml -i inventory.ini

PLAY [Exam4] **********************************************************************************************************************

TASK [Check before interface description] *****************************************************************************************
ok: [vyos01]
ok: [vyos02]

TASK [Check before interface description debug] ***********************************************************************************
ok: [vyos01] => {
    "result.stdout_lines": [
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
        ]
    ]
}
ok: [vyos02] => {
    "result.stdout_lines": [
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

TASK [Set descriptions] ***********************************************************************************************************
[WARNING]: To ensure idempotency and correct diff the input configuration lines should be similar to how they appear if present in
the running configuration on device
changed: [vyos01] => (item={'ethernet': 'eth1', 'description': 'loop_test1'})
changed: [vyos02] => (item={'ethernet': 'eth1', 'description': 'loop_test1'})
changed: [vyos01] => (item={'ethernet': 'eth2', 'description': 'loop_test2'})
changed: [vyos02] => (item={'ethernet': 'eth2', 'description': 'loop_test2'})

TASK [Check after interface description] ******************************************************************************************
ok: [vyos02]
ok: [vyos01]

TASK [Check after interface description debug] ************************************************************************************
ok: [vyos01] => {
    "result.stdout_lines": [
        [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
            "Interface        IP Address                        S/L  Description",
            "---------        ----------                        ---  -----------",
            "eth0             10.0.0.2/24                       u/u  ",
            "eth1             192.168.1.252/24                  u/u  loop_test1",
            "                 192.168.1.254/24                       ",
            "eth2             192.168.2.252/24                  u/u  loop_test2",
            "                 192.168.2.254/24                       ",
            "lo               127.0.0.1/8                       u/u"
        ]
    ]
}
ok: [vyos02] => {
    "result.stdout_lines": [
        [
            "Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down",
            "Interface        IP Address                        S/L  Description",
            "---------        ----------                        ---  -----------",
            "eth0             10.0.0.3/24                       u/u  ",
            "eth1             192.168.1.253/24                  u/u  loop_test1",
            "eth2             192.168.2.253/24                  u/u  loop_test2",
            "lo               127.0.0.1/8                       u/u"
        ]
    ]
}

PLAY RECAP ************************************************************************************************************************
vyos01                     : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vyos02                     : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$
```
