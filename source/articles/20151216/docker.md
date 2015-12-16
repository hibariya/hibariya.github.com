---
title: Docker の本を読んでまばたき
---

「複雑でたいへんそう」という心理的なハードルを感じていた Docker。[mruby-cli](https://github.com/hone/mruby-cli) で使われているし他にもこれから使いたくなる場面が出てきそうだなーと思い [Docker実践入門](http://www.amazon.co.jp/gp/product/4774176540/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=4774176540&linkCode=as2&tag=hibariya-22) と [Dockerエキスパート養成読本](http://www.amazon.co.jp/gp/product/4774174416/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=4774174416&linkCode=as2&tag=hibariya-22) を読んだ。

どういう理屈で Docker が動いているのかとか基本的な使い方を知るために「Docker実践入門」を読んだあとで、周辺のツールをもう少し見渡すために「Dockerエキスパート養成読本」をぱらぱら眺めるという流れ。ただ読んでるだけだと「ふーん」という感じで終わりそうだったので、手始めに Docker Compose を使って自分の Web サイトを作り直した。

[hibariya/hibariya.org](https://github.com/hibariya/hibariya.org)

自分がターミナルで作業しているときには [hibariya.org](http://hibariya.org/) にいる <img src='/favicon.png' alt='hibariya' style='display: inline; width: 16px; height: 16px;'> がまばたきをする。

<blockquote class="twitter-tweet" lang="en"><p lang="ja" dir="ltr">まばたきの様子です <a href="https://t.co/PRlI0W7syI">pic.twitter.com/PRlI0W7syI</a></p>&mdash; Hika Hibariya (@hibariya) <a href="https://twitter.com/hibariya/status/676949345778946049">December 16, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

(GitHub のリポジトリには何の文書もないので) 簡単な説明:

* app: Rails。今のところほぼ HTML を返すだけ。
* ttybeats: シェルへ入力がある度に WebSocket サーバへお知らせするツール。
* beatpump: WebSocket サーバ。ttybeats からのお知らせをブラウザへ中継。
* nginx: Web サーバ。

先日読んだ [マスタリング Nginx](http://www.amazon.co.jp/gp/product/4873116457/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=4873116457&linkCode=as2&tag=hibariya-22) の素振りもやりたかったという事情で無駄に Rails を使った複雑な作りになっている。

がーっと本を読んで少し手を動かすことでいくらかはコンテナに親しみを感じられるようになった気がする。書いてあったことを全部は試せていないけど、手元で作った環境を好きなところにぽんと置けるのは便利なものだなーというのを実感した。

最近は [プログラマのためのDocker教科書](http://www.amazon.co.jp/gp/product/479814102X/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=479814102X&linkCode=as2&tag=hibariya-22) とか [Docker実践ガイド](http://www.amazon.co.jp/gp/product/B0191B5FE4/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B0191B5FE4&linkCode=as2&tag=hibariya-22) というのも出たみたい (読んでない)。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=4774176540&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=4774174416&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
