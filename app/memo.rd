
▼▼▼環境構築　参考サイト


https://k-sugi.sakura.ne.jp/it_synthesis/5774/
 +
 ※※※　m1 macなのでdocker-compose.yamlのapp:dbに　　platform: linux/x86_64　の記述が必要。　※※※
 +
 https://blog.websandbag.com/entry/2019/06/13/184034
  laravelのenvファイル内では半角スペースを入れる事はできません。
  もし、半角スペースを使いたい場合は、"(ダブルクオート)で囲います。
  APP_NAME="テスト タイトル"


▼以下ファイルを作成
・
・
・

▼▼▼環境構築

準備が出来たら次のコマンドを実行して環境を構築します。

1
cd /Users/am/Desktop/zisaku1/laramy01/app
docker-compose build

構築が完了したら、出来上がったコンテナ達をバックグラウンドで起動します。

1
docker-compose up -d
プロセスを表示して動作しているか確認するには

1
docker-compose ps


Laravelのインストール
続いてLaravelのインストール作業に入ります。

まずはコンテナのシェルに入る必要があるので以下のコマンドを実行します。

1
docker exec -it laravel_app /bin/bash
Laravelのプロジェクトを作成します。
書式は次のようになります。
composer create-project "laravel/laravel=バージョン" プロジェクト名
今回はバージョン9なので次のようになります。

1
composer create-project "laravel/laravel=9.*" laravel-app
インストールが完了したらプロジェクトのディレクトリに移動します。

1
cd laravel-app
ログ等を保存するためにstorageディレクトリのパーミッションを変更します。

1
chmod 777 -R storage
アプリケーションキーを作成します。

1
php artisan key:generate
src/laravel-app/config/app.phpを修正
timezoneの設定をAsia/Tokyoに変更

src/laravel-app/.envファイルを編集し、接続するデータベース名などを設定
以下*の付いた4カ所を修正
※DB_HOSTは通常localhostだがDockerの場合、DBコンテナを指定

1
DB_CONNECTION=mysql
2
DB_HOST=laravel_db *
3
DB_PORT=3306
4
DB_DATABASE=laravel_db *
5
DB_USERNAME=laravel_user *
6
DB_PASSWORD=laravel_pass *
データベースを初期化

1
php artisan migrate
5つのテーブルが出来ていればOK

failed_jobs
migrations
password_resets
personal_access_tokens
users
コンテナのシェルから出る場合はexitコマンドを実行します。

バリデーションメッセージの日本語化
コンテナシェルにいるついでに、Laravelのバリデーションメッセージを日本語化しておくと後々便利です。
バリデーションメッセージを日本語化するには以下のコマンドを順に実行します。

1
php -r "copy('https://readouble.com/laravel/8.x/ja/install-ja-lang-files.php', 'install-ja-lang.php');"
2
php -f install-ja-lang.php
3
php -r "unlink('install-ja-lang.php');"
src/laravel-app/config/app.phpを開き、'locale'を'ja'に変更する
これでフォーム入力時のエラーメッセージ等が日本語化されます。

まとめ
これで最低限一通りの環境構築は完了です。
XAMPPやレンタルサーバー上でのLaravel開発環境構築はかなり面倒でしたが、dockerを使うとかなり楽です。
参考になれば幸いです。

おまけ
Laravelでエラーが発生し、次のようなメッセージが表示された場合

1
The stream or file "/var/www/html/laravel-posting-app/storage/logs/laravel.log" could not be opened in append mode: Failed to open stream: Permission denied The exception occurred while attempting to log
これはエラーが出たのでログに書き込もうとしたが、書き込みが出来ないというエラーです。
storage/logs/laravel.logの権限がrootになっている場合に発生します。
apacheユーザーに変更してあげないといけないのですが、単純に該当のログファイルを削除してやると自身のユーザー権限で作成し直してくれるので、そのほうが手っ取り早いと思います。