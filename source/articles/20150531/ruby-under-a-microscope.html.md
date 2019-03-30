---
title: '「Rubyのしくみ Ruby Under a Microscope」を読んだ'
---

「Ruby Under a Microscope」(Pat Shaughnessy 著) の日本語訳「Ruby のしくみ Ruby Under a Microscope」を読んだ。

<a href='http://i.loveruby.net/ja/rhg/book/' target='_blank'>RHG</a> をどきどきしながら読む感じの人とか、Ruby のつくりを知ることに多少なりとも興味のある人にとっては間違いなくおすすめの一冊。

この本は主に MRI (CRuby) について、後半では JRuby と Rubinius についても解説している。簡単とは言えない部分もあるけれど、解説はていねいだったのでなんとか最後まで読みることができた。この本を読むことで、例えば次のようなことについての情報が得られた。

* Ruby プログラムが字句解析や構文解析を経て、YARV 命令列にコンパイルされるまでの流れ
* AST をそのまま処理せず YARV 命令列にコンパイルすると何が嬉しいのか
* YARV がスタックマシンであること
* YARV 命令列はどのように実行されるのか
* Ruby の制御構造はどのような YARV 命令列として実行されるのか
* Ruby のメソッドを呼び出したとき、C の世界では何が起こっているのか
* Ruby のメソッドが11種類に分類できること
* C の世界で、オブジェクトやクラスはどのように表現されるか
* 継承ツリーのメカニズム
* ハッシュテーブルのしくみ
* クロージャという概念について
* Ruby は、Ruby におけるクロージャの実装であるブロックをどう実装しているか
* JRuby を使うことの利点
* Rubinius にできて MRI にできないこと
* さまざまな GC アルゴリズムについて

これらの情報が無くても、Ruby で平和にコードを書いているときにはそれほど困らない (良いこと)。
とはいえ、この本は面白いだけではなくて実用的な側面もありそうで、例えば変な Ruby を作りたいとか、Ruby の拡張ライブラリを書きたいと思っている人には役に立ちそうな本だと思う。

GitHub 上に「Ruby のしくみ」のサポート用リポジトリがある。
最新のバージョンを読んでいて気づいた点があれば Issue を探したり open すると良さそうです。

<a href='https://github.com/ohmsha/ruby-under-a-microscope-ja' target='_blank'>ohmsha/ruby-under-a-microscope-ja</a>

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?lt1=_blank&bc1=000000&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=hibariya-22&o=9&p=8&l=as1&m=amazon&f=ifr&ref=qf_sp_asin_til&asins=4274050653" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
