ruby on railsの学習の為に作成したサンプル
 
## 簡単な説明
 
以下の技術を使用したブログアプリです。
プログラミングの学習を目的としているので、デザインについてはおざなりになっています。
・Ruby(ruby on rails)
・ReactJS
・ActiveRepords
・Mysql

製作時間は、約15~20時間程です。

## 機能
 
- 記事一覧表示機能
- 記事詳細表示機能
- 記事投稿機能
- 管理ユーザログイン機能
- 画像ファイルのアップロード機能
 
## 使い方
 
Mysqlのデータベースが構築であることが前提です。

1. config/database.ymlの設定を行い、Mysqlへの接続情報を適用します。
2. 「rake db:seed」を実行し、テーブルの作成と初期データをします。
3. 「rails s」コマンド等でサーバ起動し、「http://{ホスト名もしくはIPアドレス}:3000/」へアクセスします。
 
## インストール
 
```
$ git clone https://github.com/ogayasuhito/ogayasu/sample
$ cd sample
$ rake db:seed
$ rails s
```
