---
title: 2月上旬の出来事
---

## 普段使いのバッグを変えた

今までは [FJALL RAVEN KANKEN](https://www.amazon.co.jp/gp/product/B01DLS32P2/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B01DLS32P2&linkCode=as2&tag=hibariya-22) の紺色+黄色のやつを使っていたんだけど、16Lだと少し心細い。PCとヘッドホンケースを入れたらあまりスペースに余裕がなくなってしまう感じ。

新しいのは少し大きめにして [MILLET TARN 25](https://www.amazon.co.jp/gp/product/B01BWLMDH8/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B01BWLMDH8&linkCode=as2&tag=hibariya-22) にした。これくらいの大きさだとちょと遠くへ行くにも安心感があっていい。それと、このバッグは上下2部屋に分けられるところがよくて、少し狭い下段の部屋には普段使わないが持っておきたい折り畳み傘とか電源ケーブルみたいなものを突っ込んでおける。

今更だけど FJALL RAVEN は手提げで使うのが便利なのではという気がしてきた。だからこれからも何かと用途はありそう。よかったよかった。

## hibariya.org の DNS を Cloudflare に移行した

Cloudflare も [API](https://api.cloudflare.com/) を公開していたので、以前やったような [たまに変わるIPアドレスを更新する](http://note.hibariya.org/articles/20150525/zerigo-api.html) ためのコードをガガガと書いた。プロセスの管理が面倒なので適当なスケジューラ (Systemd の timer) を使って、決まった時間に叩いている。Systemd の timer は cron に比べて設定が冗長で面倒だと思っていたけど、エラー含めた出力がデフォルトで journal に流れるのはいいな。というのと、こういう用途には実行可能なバイナリ形式が楽そうだなあと思った。

## アボカドをハイドロカルチャーにした

アボカドの種を水につけて栽培していたんだけど、色々面倒になってきたので栽培方法をハイドロカルチャーに変えた。容器の底に [ミリオンA](https://www.amazon.co.jp/gp/product/B0091GFTB4/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B0091GFTB4&linkCode=as2&tag=hibariya-22) と [イオン交換樹脂剤](https://www.amazon.co.jp/gp/search/ref=as_li_qf_sp_sr_il_tl?ie=UTF8&camp=247&creative=1211&index=aps&keywords=B00UFKAMD0&linkCode=as2&tag=hibariya-22) を入れて、 [ハイドロコーン](https://www.amazon.co.jp/gp/product/B00C0KG1OC/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B00C0KG1OC&linkCode=as2&tag=hibariya-22) で種を固定したらできあがり。毎日水をかえなくてよくなったし、万一容器を倒してしまっても掃除が楽そう。

ハイドロカルチャーというのは和製英語で、hydro (水) + culture (栽培) ということらしい。cultureに栽培や養殖という意味もあるというのを初めて知った。じゃあ単に水につけて栽培するのも魚の養殖もハイドロカルチャーなんだろうかという気がしてくるが、その辺はよくわからない。水で養殖してるわけじゃないんだから魚は言いすぎか。
