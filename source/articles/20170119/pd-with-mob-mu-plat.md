---
title: Android で Pure Data のヘルプを動かす
---

Pure Data に付属しているヘルプはパッチなので実際に動かしながら理解できて便利。スキマ時間にスマホで触りたい。MobMuPlat は Pure Data のパッチを開けるそうなので試してみたところだいたい動いた。

パッチには次のような感じでちょっと手を加える必要があった (`output~` を `dac~` にして、`number` の幅を広げる)。

```bash
sed -i -e 's/output~;/dac~;/g' *.pd
sed -i -re 's/X floatatom ([0-9]+) ([0-9]+) 0 /X floatatom \1 \2 5 /g' *.pd
```

Android File Transfer を使ってパッチをコピーして MobMuPlat から開くとだいたい動く。線が描画されないのはご愛嬌。
