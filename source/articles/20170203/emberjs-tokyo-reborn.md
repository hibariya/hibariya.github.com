---
title: Ember.js Tokyo Reborn へ行った
---

昨日 (2/2) の [Ember.js Tokyo Reborn](https://emberjs.doorkeeper.jp/events/56135)。LT枠もあったので最近 Ember Data まわりの悩みごとについて発表してきました。

<script async class="speakerdeck-embed" data-id="396313f98d8d42ea87a3e98b10dd80a2" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

何かを削除するアクションをしたとき、即座にサーバへ反映したいけど、そのアクションを起こしたクライアント上ではまだちょっと表示していたい。例えば Twitter の Like 一覧で Unlike してもしばらく残ってるみたいな動きを Ember + Ember Data でやるときに、もっとうまくやれないかなという内容です。

会場では、直接の解決策ではないけど、[pouchdb](https://pouchdb.com/) のようなものを使ってうまくやれないかとか、ちょっと違うかもだけど [ember-changeset](https://github.com/DockYard/ember-changeset) 便利ですよという話を聞けた。便利そう。

その他に気になった話題とか:

* `Ember.computed.filterBy` が激重で困ってる。
* Ember.js のユニットテスト使うといいよ (そういえば使ってないな...)。
* https://github.com/dopin/ember-tokyo-reborn

近所の Ember ユーザの話を聞ける貴重な時間だったなあ。それとさくらインターネットさんのオフィスから見える夜景たいへんきれいでした。

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">かわいい。 <a href="https://t.co/CXl72OGOt4">pic.twitter.com/CXl72OGOt4</a></p>&mdash; Hibariya (@hibariya) <a href="https://twitter.com/hibariya/status/827128229546782723">February 2, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
