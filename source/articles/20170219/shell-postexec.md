---
title: シェルでコマンドの実行前後をフックする
---

私達の使うアプリケーションは色々な音を出します。通知やエラーを知らせる効果音、たまにジングル (短かい音楽) を鳴らすものもあります。好みや事情によって無効にしている人も少なくないと思いますが、個人的には鳴らせるときには鳴らす方が好みです。なので、毎日使うアプリケーションのひとつであるシェルからも音が出ると楽しいのではないかと思います。例えば、コマンドを実行するときに効果音を出してみたり、失敗したとき (`$? -ne 0`) には悲しい感じの音が出るとか。もっと発展させて、状況に応じてリアルタイムにサウンドを作り出すとか。

そんな「音の鳴るシェル」作りの一環として、今回はコマンド実行の前後で音を出す方法を考えてみます。どうすればコマンドを叩くタイミングで任意の処理を実行できるのでしょう。1年くらい前に [シェルを操作する](http://note.hibariya.org/articles/20160118/pty-shell.html) 記事を書きました。この方法ではシェルの入出力を操作できますが、シェル上で実行されたコマンドの実行結果は得られません。そこで、シェルの機能を使ってコマンドの実行をフックし、コマンドの結果などを取得する方法を調べました。

## fish

fish では [イベントハンドラ](http://fishshell.com/docs/current/index.html#event) というかたちでコマンド実行前後の処理を実装できます。function 定義にイベントを指定しておくと、イベントが発火されたタイミングでその function が実行されます。この仕組みを利用してコマンド実行前後をフックするには、組込みの `fish_preexec` と `fish_postexec` イベントが使えます。

```fish
function my_preexec --on-event fish_preexec
  echo "preexec: $argv[1]"
end

function my_postexec --on-event fish_postexec
  echo "postexec: $argv[1] ($status)"
end
```

実行してみましょう。

```
$ uname
preexec: uname
Linux
postexec: uname (0)
$ hi
preexec: hi
fish: Unknown command 'hi'
postexec: hi (127)
```

ちなみに function 定義には `--on-variable` や `--on-signal` というオプションもあり、値の変化やシグナルの受信を監視できて便利そうです。

```fish
function my_pwd_changed --on-variable PWD
  echo "PWD: $PWD"
end

function my_term_trap --on-signal SIGUSR1
  echo "SIGUSR1 received"
end
```

実行結果は次のようになります。

```
$ cd /tmp/
PWD: /tmp
$ kill -USR1 %self
SIGUSR1 received
```

## zsh

zsh の場合は、`add-zsh-hook` でフックを登録できます。`fish_postexec` にあたるものは無いので、プロンプト表示前に実行される `precmd` を、コマンド実行後のフックとして代用しました。ここには実行したコマンドが渡ってくるわけではないので、もし必要ならばもう少し工夫が要りそうです。

```zsh
autoload -Uz add-zsh-hook

add-zsh-hook preexec my_preexec
add-zsh-hook precmd my_precmd

my_preexec() {
  echo "preexec: ${1}"
}

my_precmd() {
  echo "precmd (${?})"
}
```

実行結果です。

```
% uname
preexec: uname
Linux
precmd (0)
% hi
preexec: hi
zsh: command not found: hi
precmd (127)
```

## bash

bash では [`bash-preexec`](https://github.com/rcaloras/bash-preexec) を使うと比較的簡単に実現できました。zsh と同様、コマンド実行後のフックは `precmd` で代用しています。実行結果は zsh の場合とほぼ同じなので省略します。

```bash
# https://github.com/rcaloras/bash-preexec
source ./bash-preexec.sh

preexec_functions+=(my_preexec)
precmd_functions+=(my_precmd)

my_preexec() {
  echo "preexec: ${1}"
}

my_precmd() {
  echo "precmd ($?)"
}
```

## おわりに

私がよく使うシェルを対象に、コマンド実行前後をフックする方法について調べました。別の実現方法としては ptrace(2) や DTrace、trap(1) を駆使することで似たようなことができるかもしれません (試してない)。が、私の知っている範囲だとシェルを使うのが比較的シンプルなやり方だと思いました。もしもっと良いやり方があれば教えてください。
