---
title: 'Stripe の Subscription 機能を Docker だけで素早く試す'
---

Stripe の [ドキュメント](https://stripe.com/docs/billing/subscriptions/overview) によると、この機能を使っていわゆるサブスクリプション型の課金の仕組みを実装できる。公開されている [参考実装](https://github.com/stripe-samples/subscription-use-cases/tree/master/fixed-price-subscriptions) には、Netflix のような毎月固定額の支払いに対応する例がある。ドキュメントだけでも十分に分かりやすいものの、これを実際に手元で動かすことで、何がどうやって動いているのかさらに理解が深まった。手元で動かすには Docker さえあれば大丈夫。

前提条件:

* 手元のマシンに Docker がインストールされていること。
* Stripe のアカウントを持っていること。
* 参考実装で使う商品 (Product) として Basic と Premium を作成済みであること ([手順](https://stripe.com/docs/billing/subscriptions/fixed-price#create-business-model))

## ターミナル上でやること

全体を通して、シェル上で実行する操作は以下の通り。

```shell
# Stripe CLI のセットアップ
mkdir -p ~/.config/stripe
touch ~/.config/stripe/config.toml
docker run --rm -it \
  --volume ~/.config/stripe/config.toml:/root/.config/stripe/config.toml \
  stripe/stripe-cli login

# Stripe CLIで、飛んでくる webhook のリクエストをアプリケーションサーバに転送する
docker run --rm -it \
  --volume ~/.config/stripe/config.toml:/root/.config/stripe/config.toml \
  --name stripe-cli \
  --publish 4242:4242\
  stripe/stripe-cli listen --forward-to http://localhost:4242/stripe-webhook

git clone https://github.com/stripe-samples/subscription-use-cases.git
cd subscription-use-cases

# アプリケーションの実行に必要な環境変数を設定する
cp -p .env.example fixed-price-subscriptions/server/ruby/.env
$EDITOR fixed-price-subscriptions/server/ruby/.env

# Stripe CLI と同じネットワークを使いつつ、アプリケーションサーバを起動する
docker run --rm -it \
  --workdir=/work \
  -v $(pwd):/work \
  --network container:stripe-cli \
  ruby:2.7.1 bash -c \
    "cd fixed-price-subscriptions/server/ruby && bundle && bundle exec ruby server.rb -o 0.0.0.0"
```

必要なコマンドはこれだけ。今回は Ruby の実装を使うので、Ruby の実行できるコンテナを用意する。また、仕組み上 Stripe からの webhook を受け取る口も必要なので、そのために Stripe CLI の Docker イメージも使っている。ひとつひとつは少し複雑なので、それぞれ順番に見ていこう。

### Webhook を受け取れるようにする

参考実装のアプリケーションサーバは手元のマシンで動くので、Stripe から飛んでくる webhook のリクエストをどうにかして受け取れるようにする必要がある。そこで Stripe のコマンドラインツール Stripe CLI の出番になる。Docker イメージが提供されているので、すぐに使える。

```shell
mkdir -p ~/.config/stripe
touch ~/.config/stripe/config.toml
docker run --rm -it \
  --volume ~/.config/stripe/config.toml:/root/.config/stripe/config.toml \
  stripe/stripe-cli login
```

Stripe CLI はログイン時にブラウザを開こうとするものの、ブラウザの入っていないコンテナ上で実行しているので当然うまくいかない。ただ、失敗したタイミングで URL が表示されるので、それを使って自分で開けば問題ない。ログインが完了すると、`~/.config/stripe/config.toml` に認証情報が書き込まれる。

<img alt="出力されているURLを使ってログインする" src="https://rip.hibariya.org/post/try-stripe-subscriptions-with-docker/Selection_357.png" style="max-width: 670px">

準備ができたので、早速 webhook を待ち受ける。

```shell
docker run --rm -it \
  --volume ~/.config/stripe/config.toml:/root/.config/stripe/config.toml \
  --name stripe-cli \
  --publish 4242:4242\
  stripe/stripe-cli listen --forward-to http://localhost:4242/stripe-webhook
```

これによって webhook のリクエストはすべて `http://localhost:4242/stripe-webhook` に転送される。ここで転送先URLに `localhost` を使うことができるのは、次のステップでアプリケーションサーバを走らせるときにこのコンテナと同じネットワークスタックを使うためだ。また、そのためにあらかじめコンテナに名前を付けている。これによって、別のコンテナを走らせるとき `--network container:stripe-cli` と既存のコンテナを指定して同じネットワークスタックを使うことができる。

<img alt="" src="https://rip.hibariya.org/post/try-stripe-subscriptions-with-docker/Selection_354_pixelized.png" style="max-width: 670px">

コンテナが起動すると、`whsec_` で始まる webhook secret が出力される。これは次のステップで使う。

### アプリケーションサーバを起動する

参考実装を GitHub から clone しよう。冒頭でも述べたように、ここでは Ruby の実装を使う。

```shell
git clone https://github.com/stripe-samples/subscription-use-cases.git
cd subscription-use-cases
```

アプリケーションサーバを起動するには、いくつかの環境変数を設定する必要がある。アプリケーションは `.env` から変数を読み取るので、リポジトリのルートにある `.env.example` を `.env` という名前でアプリケーションサーバのディレクトリにコピーする。お好みのエディタで環境変数を設定する。

```shell
cp -p .env.example fixed-price-subscriptions/server/ruby/.env
$EDITOR fixed-price-subscriptions/server/ruby/.env
```

`STRIPE_WEBHOOK_SECRET` には前のステップで手に入れた webhook secret を設定する。その他の値は Stripe のダッシュボードで確認できる。

Keys:
<img alt="ダッシュボードの開発者ページ" src="https://rip.hibariya.org/post/try-stripe-subscriptions-with-docker/Selection_353_highlighted.png" style="max-width: 670px">

Prices:
<img alt="商品ページの詳細" src="https://rip.hibariya.org/post/try-stripe-subscriptions-with-docker/Selection_352_highlighted.png" style="max-width: 670px">

最後に、ruby コンテナの中で依存ライブラリをインストールしつつアプリケーションサーバを起動する。前述の通り、`--network container:stripe-cli` で Docker に Stripe CLI のコンテナと同じネットワークスタックを使うように知らせる。アプリケーションをホスト側のブラウザから開くため、`-o 0.0.0.0` もここでは必要になる。このオプションによって、Sinatra に全てのネットワークインターフェースを listen するように知らせている。

```shell
docker run --rm -it \
  --workdir=/work \
  -v $(pwd):/work \
  --network container:stripe-cli \
  ruby:2.7.1 bash -c \
    "cd fixed-price-subscriptions/server/ruby && bundle && bundle exec ruby server.rb -o 0.0.0.0"
```

これで `localhost:4242` を手元のブラウザで開き、subscription の機能が動作している様子を確認できるようになったはずだ。この参考実装では、subscription の作成、変更、キャンセルなどを試すことができる。Stripe CLI の出力は特定のイベントがどのタイミングで起きるかを知るのに便利だ。

<img alt="" src="https://rip.hibariya.org/post/try-stripe-subscriptions-with-docker/Selection_361.png" style="max-width: 670px">

