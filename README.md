# h2o_installer

[H2O](https://github.com/h2o/h2o) をインストールするためのスクリプトなど．

# Note

- Ubuntu 15.04 LTS で動作確認済
- systemdへの設定(/src/service.sh, /res/h2o.service)
- ISUCON5予選過去問用に作成
- オレオレ証明書によるHTTP/2設定ファイル

# Use

VM上などで

`````
git clone https://github.com/WalkingMask/h2o.git
cd h2o
sudo sh run.sh
`````

再起動して，Ubuntuであれば

`````
systemctl status h2o
`````

と実行して active になっていれば成功．

# Option

/opt/pre.sh と /opt/post.sh を書き換えることで用途変更/拡張可能...？  
逆にその2つを消すと /res/h2o_example.conf を使って素の設定でインストールされる．  
run.sh の sh service.sh をコメントアウトすれば systemd への設定はしない．


# Idempotence

冪等性が守られるように心がけ中.

# Reference

[H2O wiki](https://h2o.examp1e.net/index.html)  
[h2o構築作業メモ](http://qiita.com/naotospace@github/items/badedb8c8272ad56118d)  
[自宅サーバーUbuntuをhttp/2化した](http://new-pill.hatenablog.com/entry/2015/12/23/010330)  
[h2o systemd service file作った](https://negima.mobi/2015/10/2092)  
[H2O Reverse Proxy](https://github.com/h2o/h2o/wiki/Reverse-Proxy)
