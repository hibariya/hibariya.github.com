# Thorの便利な使い方

[Retter](https://github.com/hibariya/retter)を作るにあたってとても便利に使えたThorの簡単な使い方を、やりたいこと別に紹介します。
といってもだいたいは[Wiki](https://github.com/wycats/thor/wiki)に書いてあることしか書けないんですが、何しろ英語ですし、自分なりにまとめてみようと思います。

## 便利なRakeとして使う

便利なRakeというのは主に引数とオプションの扱い方のことです。素のRakeは引数を渡したいときは環境変数として渡さないといけなかったのですが、これがとても面倒なのでした。こんなふうに。

~~~~
TYPE=foo rake setup
~~~~

thorだともう少し無理なく書けます。

~~~
thor setup --type foo
~~~

とか、

~~~
thor setup foo
~~~

とか。

