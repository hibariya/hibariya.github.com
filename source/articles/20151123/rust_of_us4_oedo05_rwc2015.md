---
title: "Idobata会議, Rust of Us, 大江戸Ruby会議そして RWC"
---

最近の外出記録。

<h2 id="idobata-kaigi">10/29 <a href="https://idobata.doorkeeper.jp/events/31060">Idobata会議02:Rescheduled</a></h2>

これまでの Idobata の取り組みを基調講演で [報告](https://github.com/flada-auxv/todobackend-rust) した。
当日の様子は esa 社の方が [まとめて](https://docs.esa.io/posts/154) くださっている。
普段 Idobata を使っている人たちと直接会って話をしたことで、自分たちがこれまでやろうと思っていたことと求められていることとの距離を確認できたと思う。

<h2 id="rust-of-us">10/31 <a href="https://rust-of-us.doorkeeper.jp/events/32615">Rust of Us - Chapter 4</a></h2>

今回で4回目。さいきんロゴもできた Rust of Us。Eric Findlay と cosmo がやってきた。

[hokaido](https://github.com/idobata/hokaido) を Rust で書いていたものが動くようになったので、その [成果発表](https://speakerdeck.com/hibariya/introducing-hokaido) をしてきた。
デモをしつつ触ってもらっていたところ、Mac で動作しないというバグが判明してその場で [パッチをもらう](https://github.com/idobata/hokaido/pull/2)。
さらに、[docopt のマクロでよりシンプルに書く方法](https://github.com/idobata/hokaido/compare/hakodate...cosmo0920:use-docopt-macros) も教えてもらったけど、nightly でしか動かないため投入できなかった。

<script async class="speakerdeck-embed" data-id="dfaeaa76f2454137b4d58fe7a73c0248" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

takkanm は [さいきん気になった Rust 関連の記事](https://gist.github.com/takkanm/13776f716cce525753aa) について話していた。
その中の crate を作るためのプラクティスが勉強になったので、後日 [pty-rs](https://github.com/hibariya/pty-rs) でいくつか試した。
具体的には組込みの Lint を強化し [rustc-clippy](https://github.com/Manishearth/rust-clippy) で微妙なコードを修正、さらに [rustfmt](https://github.com/nrc/rustfmt) で見た目のスタイルを統一した。rustfmt には概ね満足しているのだけど、文字列リテラル (複数行) の中も変更してきてしかもあまり綺麗に見えない結果になることがあってままならないところがある。

flada_auxv は [iron](https://github.com/iron) の話をしていた。iron 本体はシンプルに保たれており、必要に応じてユーザがプラグインやミドルウェアを組み合わせるのが iron way というような話だった気がする。しかしそのときはあまり聞けておらず特に資料も残っていなかったので、もっとよく人の話を聞いておけばよかったと思っている。

<h2 id="oedo-ruby-kaigi">11/08 <a href="http://regional.rubykaigi.org/oedo05/">大江戸Ruby会議05</a></h2>

感想を書きはじめると長くなりそう。

濃いプログラムだったのでだいたいメイン会場の7階にいて話をきいていた。午後にコーヒーブレイクの時間があって、13階で電源につなぎつつ普段顔をあわせない人たちと話したりだらっとできて快適だった。
その日懇親会には参加できなかったので、江渡さんの招待講演をきいたあと帰宅。

<h2 id="rwc">11/12 - 13 <a href="http://2015.rubyworld-conf.org/">RubyWorld Conference 2015</a></h2>

初参加 の RWC。島根知事や松江市長が Ruby について話していたり、制服を着た中学生か高校生が Matz の基調講演をきいている様子の別世界感が印象的だった。

1日目のレセプションは普段会わない人や会ったことがなかった人と話して回った。その日はアルコール抜きで過ごしてみたところ、いつもより人の話をちゃんと聞けて意外に良かった。2日目の夜に地ビールを飲んでから帰宅。ukstudio に TOEIC 受験の話をきいた。まだ模試しかやったことがなくて、もう少し本番の話を聞いておけばよかった。

Linda Liukas の「Principles of Play」が一番の収穫だった。身近な子供たちのためにできることがあるといいな。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=4757420900&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=4900790052&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
