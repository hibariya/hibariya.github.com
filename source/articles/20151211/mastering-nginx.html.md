---
title: マスタリング Nginx を読んだ
---

これまで真面目に触ってこなかった Nginx についてまとまった情報を日本語で読みたいという目的で購入。
Rails を動かしている Unicorn や Puma にリクエストを投げるようなリバースプロキシの設定から、レスポンスのキャッシュや圧縮、過度なリクエストの抑止など、普通に触っていればやりたくなりそうなことについてひととおり書かれており助けになった。最後の章にはパフォーマンスやリソースに関するトラブルシューティング例もあり、よくある問題を未然に防ぐための参考になると思う。

Nginx が Memcached と連携できることや XSLT で XML を変換できること、メールサービスのプロキシができるということをこれまで知らなかった。Memcached をキャッシュにうまく活用できるとかっこよさそう。メールモジュールを活用してる人は結構いたりするんだろうか。

<iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=hibariya-22&o=9&p=8&l=as1&asins=4873116457&ref=qf_sp_asin_til&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
