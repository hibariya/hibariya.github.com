---
title: pty-shell でシェルを操作する
---

以前、[PTY を使ってシェルの入出力を好きなようにする](http://note.hibariya.org/articles/20150628/pty.html) 方法を調べて、それを Rust でやるために [pty という crate を作っ](http://note.hibariya.org/articles/20150718/pty-rust-of-us.html) た。この pty を使ってこれまでに [hokaido](http://github.com/idobata/hokaido) のようなターミナル共有ツールとか [シェルへの入力をどこかへ通知するツール](https://github.com/hibariya/hibariya.org/tree/master/ttybeats) を作った。

これらには「ターミナルを立ち上げてその入出力をフックする」という共通の処理がある。けれど pty が用意している `pty::fork()` は、新しい疑似端末 (PTY) を割り当てた子プロセスを生成するだけだ。実際には他にも必要な処理がある。

* 子プロセスの制御端末に適切な画面サイズを設定する。
* 標準入力を子プロセスへ即座に伝えるため、親プロセスの制御端末を raw モードにする。
* 親プロセスへの入力を子プロセスの標準入力に送り、子プロセスの出力を親プロセスの標準出力に送る。
* 子プロセスでシェルを起動する。

意味もなく同じコードを何度も書くのはつらい。とはいえこれら一連の処理は、pty crate として用意するには少し具体的すぎる気がする。そういうわけで、シェルに特化した拡張という意味で pty-shell という crate をもうひとつ用意した。

[hibariya/pty-shell](https://github.com/hibariya/pty-shell)

pty-shell は「ターミナルを立ち上げてその入出力をフックする」ための簡単な方法を提供する。
具体的には子プロセスとしてシェルを起動し、親プロセスの入出力を子プロセスのシェルにプロキシする。

<script async class="speakerdeck-embed" data-slide="11" data-id="c29a52fffd1f440bbe55ae2bc2bfa54f" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
