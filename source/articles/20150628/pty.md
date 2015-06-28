---
title: PTY を使ってシェルの入出力を好きなようにする
---

あるプログラム (例えばシェル) を実行して、その入出力を好きなようにしたいことがある。
次のようなことができればいい。

* 入出力を検知して任意の処理ができる。
* 入出力は行単位ではなく文字単位くらいの細かさ (改行を待たない)。
* 普通の文字だけでなくその間に挟まっているエスケープシーケンスも取得できる。
* Ctrl+C のような特殊文字が送られた場合もそれを検知できる。

既存のもので例えるなら script(1) にできることに近い。
こんなふうに入出力を好きにできれば、キーを入力するたびに「音を鳴らしたり」とか「ターミナルの様子を遠くの誰かとありのまま共有したり」とか、そういったことができて嬉しい。簡単なターミナルマルチプレクサも実装できたりしないかな。

上で箇条書きしたようなことは子プロセスに新たな端末を割り付けることによって実現できる。
子プロセスに割り付けた端末を親プロセスに監視させる。
おおざっぱに描くと次のようなイメージ (矢印は入出力)。

```
親プロセス  <--->  PTY マスタ  <--->  PTY スレーブ  <--->  子プロセス
```

PTY (疑似端末) にはマスタとスレーブがあり双方向パイプのように振る舞う。マスタに書き込んだものはスレーブから読め、スレーブに書き込んだものはマスタから読める。これを使えば、子プロセスとして実行しているシェルの入出力を親プロセス側から好きなようにできそうだ。

実現方法をおおざっぱに書くと次の手順になる (Linux と Mac OSX 上で動作確認した)。

1. PTY のマスタを開いて fork する
2. 子プロセスで...
  1. 新しいセッションで PTY のスレーブを開く
  2. PTY の属性を親プロセスのものから引き継ぐ
  3. PTY スレーブのファイル記述子を標準入出力に複製する
  4. exec する
3. 親プロセスで...
  1. 端末を raw モードにする
  2. 親プロセスの全ての入力を子プロセスに送る
  3. 子プロセスの全ての出力を親プロセスで出力する

最終的に [<a href='#entire_source'>こういう処理</a>] をすることになった。
必要な情報はだいたい APUE に書いてあったので、より詳しく正確に知りたい人にはそちらがおすすめ。

## 1 PTY のマスタを開いて fork する

前準備として親プロセスの termios と winsize をとっておく。このふたつの構造体は、接続されている端末の振舞いやサイズを表現している。
termios を得るために tcgetattr(3) を呼び出し、winsize を得るために ioctl(2) でリクエスト TIOCGWINSZ を投げる。

```c
tcgetattr(STDIN_FILENO, &orig_termios);
ioctl(STDIN_FILENO, TIOCGWINSZ, (char *)&orig_winsize);
```

ここで得た値はあとで子プロセスに端末を割り付けるときに使う。
それと親プロセスの端末の振舞いを変えるためにも使う。

PTY マスタを開くには posix_openpt(3) を呼び出す。引数には open(2) と同じように開くときのオプションを指定できる。

```c
pty_master = posix_openpt(O_RDWR);
```

PTY スレーブにアクセスするためには事前に grantpt(3) と unlockpt(3) を呼び出しておく必要があるらしい。後でスレーブを開く予定なのでここで準備しておく。
grantpt はマスタに対応するスレーブの所有者を呼び出したプロセスの実 UID にし、モードを 0620 に設定する。
unlockpt はマスタに対応するスレーブのロックを解除する。

```c
grantpt(pty_master);
unlockpt(pty_master);
```

PTY スレーブは open(2) で開く。ptsname(3) に PTY マスタのファイル記述子を渡すことで PTY スレーブのデバイスファイル名を得られる。

```c
pts_name = ptsname(pty_master);
```

ここから先は fork して親と子に分かれる。スレーブはこの後、子プロセスで開く。

## 2-1 新しいセッションで PTY のスレーブを開く

まずは子プロセス側の処理に進む。この子プロセスは最終的に bash になるのだけど、その前に新たな端末を用意して割り付ける。

ひとつのセッションはひとつの端末を持てる。持てる端末はひとつだけだ。
でも困ったことに親プロセスには既に端末が割り付けられている。だからこのままでは子プロセスに新たな端末を割り付けられない。

そこで、まずは子プロセスを新たなセッションのセッションリーダーにする。
そのために setsid(2) を呼ぶ。新たなセッションにはまだ端末が割り付けられていないので、これで PTY スレーブを開けるようになった。

```c
setsid();

pty_slave = open(pts_name, O_RDWR);
```

Linux や Mac OSX では、端末を持たないプロセスがスレーブを開くと自動的にそのプロセスの端末として割り付けられる。もしこの動作をさせたくない場合はオプションに O_NOCTTY を指定すると良いらしい。

## 2-2 PTY の属性を親プロセスのものから引き継ぐ

termios や winsize は端末の振舞いやサイズを表現している。
今回の用途を考えると、子プロセスの端末は親プロセスと同じ振舞い・同じサイズであってほしい。
冒頭で用意しておいた termios と winsize を新しい PTY に設定しよう。

```c
tcsetattr(pty_slave, TCSANOW, &orig_termios);
ioctl(pty_slave, TIOCSWINSZ, &orig_winsize);
```

tcsetattr(3) の第二引数には動作オプションを指定できる。TCSANOW を指定すると即座に反映してくれるとのこと。

## 2-3 PTY スレーブのファイル記述子を標準入出力に複製する

PTY スレーブのファイル記述子を標準入力・標準出力・標準エラー出力として複製する。PTY スレーブはもう使わないので閉じる。

```c
dup2(pty_slave, STDIN_FILENO);
dup2(pty_slave, STDOUT_FILENO);
dup2(pty_slave, STDERR_FILENO);

close(pty_slave);
```

## 2-4 exec する

子プロセスには新しい端末が割り付けられて入出力は端末に接続されている状態になった。これで目的のプログラムを実行する準備ができた。`bash` を exec(3) しておしまい。

```c
execvp("bash", NULL);
```

## 3-1 端末を raw モードにする

親プロセスで fork したところまで戻ろう。fork した後、親プロセスでは子プロセスの入出力を制御する処理を行う。そのために端末の設定を少し弄る必要がある。

このプログラムが完成すると、最終的にはキー入力が bash に渡るまでに2つの端末を経由することになる。親プロセスに割り付けられている端末と子プロセスに割り付けた端末の2つだ。入力は次のように流れていく。

```
親プロセスの端末 -> 親プロセス -> 子プロセスの端末 -> 子プロセス
```

端末は、デフォルトの状態だと入力を行単位で処理する「カノニカルモード」になっている。このおかげで行編集ができるし、bash の動いている子プロセスの端末はデフォルトのままでいい。
一方、親プロセスの端末がカノニカルモードになっていると改行文字が入力されるまで入力を検知できなくて都合が悪い。
これではキー入力のたびに音を鳴らしたりターミナルの様子を遠くの誰かに知らせることができなくなってしまうからだ。
元々やりたかったことを実現するためには、キーボードで入力された a という文字を即座に (改行文字の入力を待たずに) 子プロセスの端末へ渡したり他のファイルやソケットに書いたりできてほしい。

この問題を解決するために親プロセスの端末を「raw モード」に変更する。raw モードでは入力が1文字ずつ渡されるようになる。
さらに、特殊な文字処理もされなくなる。例えば Ctrl+C を入力しても SIGINT は送られない。
カノニカルモードをステンドグラスの窓だとすると raw モードは透明なガラス窓みたいだ。本来なら端末はひとつでよいのだから親プロセスの端末は透明くらいがちょうどいい。

raw モードに変更するには termios の各種フラグを次のように変更して tcsetattr で反映する。

```c
new_termios.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
new_termios.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
new_termios.c_cflag &= ~(CSIZE | PARENB);
new_termios.c_cflag |= CS8;
new_termios.c_oflag &= ~(OPOST);
new_termios.c_cc[VMIN]  = 1;
new_termios.c_cc[VTIME] = 0;

tcsetattr(STDIN_FILENO, TCSAFLUSH, &new_termios);
```

これで親プロセスはキー入力をすぐ検知して直ちに子プロセスへ渡せるようになった。

ここで変更しているのは親プロセスの端末だけなので子プロセスの端末はデフォルト (カノニカルモード) のままになっている。
そのおかげで実際に動くプログラム (bash) から見ると入力は行単位で処理されているように見える。Ctrl+C も SIGINT になる。

## 3-2 親プロセスの全ての入力を子プロセスに送る

親プロセスではもういちど fork する。これは入力と出力を同時に処理したいからなので fork 以外の方法で実装してもいい。
この子プロセスでは親プロセスへの入力を PTY マスタへ書き込む。
PTY マスタへ書き込んだ文字列は 「PTY スレーブが端末として割り付けられているプロセス (ここでは bash)」への入力となる。

```c
for ( ; ; ) {
  nread = read(STDIN_FILENO, buf, BUFFSIZE);

  if (nread < 0 || nread == 0) break;

  if (write(pty_master, buf, nread) != nread) break;
}
```

ここは入力をハンドルするチャンス。
PTY マスタへ書き込みつつ、音を鳴らしたり他のファイルやソケットに書いたりできる。

## 3-3 子プロセスの全ての出力を親プロセスで出力する

一方の親プロセスでは「PTY スレーブが端末として割り付けられているプロセス (bash)」の出力が PTY マスタから読めるのでそれを親プロセスの出力として書き出す。
ここは出力をハンドルをするチャンス。

```c
for ( ; ; ) {
  if ((nread = read(pty_master, buf, BUFFSIZE)) <= 0) break;

  if (write(STDOUT_FILENO, buf, nread) != nread) break;
}
```

ここまでで、入出力を好きにするという意味ではやりたいことはだいたいできた。
最後に、親プロセスが終了する直前に端末を raw モードから元の状態 (普通はカノニカルモード) へと戻すのを忘れずに。とっておいた termios を使う。

```c
tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
```

これをやらないとプログラムの終了後ターミナルが壊れてぎょっとすることに。

<blockquote class="twitter-tweet" lang="en"><p lang="ja" dir="ltr">今までよく分かってなかったこのターミナルぶっこわれた状態、例えば端末を raw モードから元に戻し損ねると再現できるのか (たまに見かけるのでずっと気になってた) <a href="http://t.co/UYmlh3gQYY">pic.twitter.com/UYmlh3gQYY</a></p>&mdash; Hika Hibariya (@hibariya) <a href="https://twitter.com/hibariya/status/614076255961387010">June 25, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## おわりに

<a href='#entire_source'>できたコード</a> を実行すると、うまくいけば新たなセッションで bash が起動する。端末が変わっているかどうかは tty(1) で確認できる。
この仕組みをもとに入出力のタイミングで任意の処理を実行すれば、シェルを操作しながら音を鳴らしたりそれを遠くの誰かと共有したりできるようになる。よかったよかった。

色々端折っていると思うので、より詳しくは APUE (Advanced Programming in the UNIX Environment) をご確認ください。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=B00KRB9U8K&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>

<h3 id='entire_source'>コード</h3>

説明を簡単にしたくて、エラー処理を省き、終了処理を最低限にした手続きを main にドカッと書いたもの。

```c
#define _XOPEN_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/ioctl.h>

#define BUFFSIZE 512

int
main() {
  struct termios orig_termios, new_termios;
  struct winsize orig_winsize;
  int pty_master, pty_slave;
  char *pts_name;
  int   nread;
  char  buf[BUFFSIZE];
  pid_t pid;

  tcgetattr(STDIN_FILENO, &orig_termios);
  ioctl(STDIN_FILENO, TIOCGWINSZ, (char *)&orig_winsize);

  pty_master = posix_openpt(O_RDWR);
  grantpt(pty_master);
  unlockpt(pty_master);

  pts_name = ptsname(pty_master);

  if (fork() == 0) {
    setsid();

    pty_slave = open(pts_name, O_RDWR);
    close(pty_master);

    tcsetattr(pty_slave, TCSANOW, &orig_termios);
    ioctl(pty_slave, TIOCSWINSZ, &orig_winsize);

    dup2(pty_slave, STDIN_FILENO);
    dup2(pty_slave, STDOUT_FILENO);
    dup2(pty_slave, STDERR_FILENO);
    close(pty_slave);
    execvp("bash", NULL);
  } else {
    new_termios = orig_termios;

    new_termios.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
    new_termios.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    new_termios.c_cflag &= ~(CSIZE | PARENB);
    new_termios.c_cflag |= CS8;
    new_termios.c_oflag &= ~(OPOST);
    new_termios.c_cc[VMIN]  = 1;
    new_termios.c_cc[VTIME] = 0;

    tcsetattr(STDIN_FILENO, TCSAFLUSH, &new_termios);

    if ((pid = fork()) == 0) {
      for ( ; ; ) {
        nread = read(STDIN_FILENO, buf, BUFFSIZE);

        if (nread < 0 || nread == 0) break;

        if (write(pty_master, buf, nread) != nread) break;
      }

      exit(0);
    } else {
      for ( ; ; ) {
        if ((nread = read(pty_master, buf, BUFFSIZE)) <= 0) break;

        if (write(STDOUT_FILENO, buf, nread) != nread) break;
      }
    }
  }

  kill(pid, SIGTERM);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);

  return 0;
}
```
