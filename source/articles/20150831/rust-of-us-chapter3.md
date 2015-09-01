---
title: 'Borrow と AsRef について調べて Rust of Us へ行った'
---

<a href="https://rust-of-us.doorkeeper.jp/events/26870" target="_blank">前回</a> は話す内容としては特にテーマもなく [Rust で PTY を使う](/articles/20150718/pty-rust-of-us.html) 話をしてきた。
<a href="https://rust-of-us.doorkeeper.jp/events/28471" target="_blank">今回</a> は少し変わって、各々 <a href="https://doc.rust-lang.org/nightly/book/" target="_blank">TRPL</a> の好きなセクションについて事前に調べてきて発表するという内容だった。

そういうわけで、最近 API Doc でよく見かける `AsRef` が個人的に気になっていたのでそれについて調べて分かったことを話してきた。発表に使った資料は Qiita に置いている。

<a href="http://qiita.com/hibariya/items/b24f893f88d0dc931c61" target="_blank">Borrow and AsRef - Qiita</a>

前回と同様、それぞれ自分の知っていることを話したり知らないことを他の参加者に教えてもらったりという感じの場だった。
聞くだけではなくて話す、というのにはふたつ良い点があると感じている。

まず、発表するために準備をするとそれだけで勉強になる。人に何かを伝えるためには実際に伝えることよりも広い範囲を把握していないと難しくて、今回は `Borrow` と `AsRef` について話すために Rust の基礎を全体的に復習する必要があったし、今まで曖昧にしてきた部分や知らなかった概念にも触れることにもなった。人に説明するために情報をまとめる時間は自分用のメモ作りと比べてずっと濃い。

それに、何か話すことでバランスが取れる。自分の力だけでは限界があるから人の集まるところに話を聞きにきているのだけど、ただ話を聞きにいく (情報をもらう) だけではちょっと申し訳ないかなという気になることがある。何でもいいから何らかのかたちでバランスを取りたくて、例えば自分の知ったことを共有することで「受け取る」だけでなく「交換」しているような気になれるのだった。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=B00LGFD3UM&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
