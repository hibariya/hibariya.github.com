# map が返す Enumerator のこと

Enumerable が提供する色々なメソッドは、受け取る筈のブロックが与えられなかった場合 Enumerator オブジェクトを返す。
Enumerator オブジェクトは、`each.with_index.with_object`みたいに each にブロックを渡さずに使うとかいうのにたまに使う。
あとは、外部イテレータのために使ったり、each 以外のメソッドを使って Enumerable のメソッドを使ったりするのに使える。

each 以外の繰り返しを行うメソッドも、ブロックを受け取らなかったときは Enumerator オブジェクトを返したりする。Enumerable#map とか。

```ruby
%w(a b c).map # => #<Enumerator: ["a", "b", "c"]:map>
```

それを使う機会は今のところないし、どういう場面で嬉しいのかもよく知らない。
使う場面は無くてもせめて使い方くらいは知っておきたいなあと思って Asakusa.rb で人に聞いたりソースに書かれたコメントを読んだりしたら何となく使い方が分かってきた。

疑問はふたつあった。

* ブロックの戻り値にあたる値はどこにどうやって渡せばいいのか
* どうすればメソッドの戻り値を得られるのか

それぞれ以下のような感じ。

* ブロックの戻り値（つまりyieldの戻り値になる値）は Enumerator#feed に渡す
* メソッドの戻り値は StopIteration#result から得られる

もっとも、↓だけでは何だかありがたみが分からないけど。

```ruby
ary  = %w(alice bob carol)
enum = ary.map

while true
  begin
    val = enum.next # ブロック引数的なもの

    enum.feed val.upcase # ブロックの戻り値的なもの
  rescue StopIteration => e
    p e.result # ["ALICE", "BOB", "CAROL"] と表示

    break
  end
end
```

while じゃなくて Kernel.#loop を使うと StopIteration を捕まえてループから脱出してくれたりする。