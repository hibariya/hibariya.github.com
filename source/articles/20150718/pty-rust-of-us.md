---
title: 'pty crate を作って Rust of Us へ行った'
---

<a href="https://github.com/hibariya/pty-rs" target="_blank">PTY に触るための crate</a> を作って、その翌週に <a href="https://rust-of-us.doorkeeper.jp/events/26870" target="_blank">Rust of Us - Chapter 2</a> へ行き、そこで知見を共有したり Rust について教わったりしてきた。

## pty crate

<a href="https://github.com/hibariya/pty-rs" target="_blank">hibariya/pty-rs</a>

さいきん調べた [PTY を使ってシェルの入出力を好きなようにする](/articles/20150628/pty.html) ための処理を Rust で簡単に書けるようにしたいという動機で作った。
この crate が提供する `pty::fork()` は、新しい疑似端末 (PTY) を割り付けた子プロセスをつくる。Ruby の `PTY.spawn` に似ている (exec はしない)。

次のように呼び出すと、疑似端末の割り付けられた子プロセスの入出力を `pty_master` 越しに読み書きできる。

```rust
let (child_process, mut pty_master) = pty::fork();
```

## Rust of Us

crate を公開することはできた。でも、API や実装の出来にはそれほど自信が持てない。最低限の動作はするものの、改善できる余地がありそうな気がする。限られた時間の中で、もっと効率よく「Rust らしいやり方」を知りたい。けれど、一人で調べているだけでは限界がある。だから、Rust について他の人の話を聞きに行くことにした。

<a href="https://rust-of-us.doorkeeper.jp/events/26870" target="_blank">Rust of Us - Chapter 2</a>

話を聞いた内容のうちのいくつかは次のようなことだった。自分からの視点そのままなので偏りがあるのと、資料を見つけられなかった分は抜け落ちている。

* エディタの話
  * <a href="https://github.com/rust-lang/rust.vim" target="_blank">rust-lang/rust.vim</a>: vim のシンタックスハイライトとか。
  * <a href="https://github.com/phildawes/racer" target="_blank">Racer</a>: 各エディタで使えるコード補完とかジャンプとか。
* <a href="https://ja.wikipedia.org/wiki/%E9%A3%9F%E4%BA%8B%E3%81%99%E3%82%8B%E5%93%B2%E5%AD%A6%E8%80%85%E3%81%AE%E5%95%8F%E9%A1%8C" target="_blank">食事する 哲学者の問題</a>
  * <a href="https://doc.rust-lang.org/nightly/book/dining-philosophers.html" target="_blank">Dining Philosophers</a> について <a href="https://twitter.com/tanaka51" target="_blank">@tanaka51</a> が調べた話。
  * モニタの話をしているところで <a href="http://www.amazon.co.jp/gp/product/4274066096/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=4274066096&linkCode=as2&tag=hibariya-22" target="_blank">dRuby 本</a> を思い出した。もう一度読もう。
* <a href="https://github.com/flada-auxv/game_of_life-rust" target="_blank">ライフゲーム</a>
  * <a href="https://twitter.com/flada_auxv" target="_blank">ふらなんとかさん</a> がライフゲームを実装する話。
  * 画面にコードを表示しながらみんなで読んだ。
* Rust と Web
  * <a href="https://twitter.com/hrysd" target="_blank">@hrysd</a> の話。
  * <a href="http://docs.hrysd.org/2015/05/11/rust_on_heroku_with_docker/" target="_blank">DockerでHerokuでRustが動いたぞ!!!</a>
  * <a href="https://github.com/hyperium/hyper" target="_blank">hyper</a>: HTTP ライブラリ。Sinatra みたいな記法のサンプルコードがあった。
* Rust と MessagePack
  * <a href="https://twitter.com/katsyoshi" target="_blank">かつよしさん</a> が Rust で MessagePack を使おうとした話。
  * <a href="https://crates.io/crates/msgpack" target="_blank">msgpack</a>: これを使う場合、依存関係にはリポジトリを直に指定した方がいいらしいとのこと。
* 使い慣れていないものについて雑談
  * <a href="https://doc.rust-lang.org/nightly/book/macros.html" target="_blank">マクロ</a>, <a href="https://doc.rust-lang.org/nightly/book/testing.html" target="_blank">テスト</a>, <a href="https://doc.rust-lang.org/nightly/book/references-and-borrowing.html" target="_blank">References and Borrowing</a>
  * <a href="https://github.com/takkanm/rust_fluent/" target="_blank">rust_fluent</a>: crate の話をしていたときに参考にした。
  * <a href="https://twitter.com/takkanm" target="_blank">@takkanm</a> が全体的に詳しくて色々教えてもらった。Book 読もう。
  * <a href="https://twitter.com/_ko1" target="_blank">ささださん</a> が目をつける部分が興味深くてためになった。マクロの記法とかメモリ管理とか、自分一人だったらそこまで深く考えなかった気がする。
* プロセスの入出力を好きにする話
  * Pseudo を適当に「プセウドオ」とか読んでいたけど正解は /ˈsjuːdəʊ/。
  * <a href="http://magazine.rubyist.net/?0041-200Special-dtrace" target="_blank">Ruby 2.0.0 の DTrace の紹介</a>: システムコールを監視するという文脈で DTrace が出てきた。

今回、参加者の中に Rust にとても詳しいという人はいないということだった。それでも、みんなそれぞれ何かしら有益な情報を持っていて、互いに自分の知っていることを発表したりツッコミを入れたりすることで得られるものがあった。

発表の後はその場で出た疑問について考えを述べ合ったり、実際にコードを書いて確認したり、参考になりそうな記事を探したりした。その結果、(少なくとも自分のなかの) いくつかの疑問や誤解が解消できた。ありがたい。また行きたいと思う。

自分はというと、 Rust について話せることはまだ少なくて、主に PTY についての話をした。

<script async class="speakerdeck-embed" data-id="ffb3b05105d749a48395ca8f1cdeaca4" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

Google Docs と Chromecast の組合せだと、スマホ片手にメモを見ながら話ができて楽だった。たとえ少人数でも人前は緊張してしまうので、なるべく楽にできるのがいい。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=B00KGVN140&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
