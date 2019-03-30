---
title: だいたい合ってるホスト
---

最近 DNS サービスを Zerigo に変更したところ、REST API もあるらしいということを知る。

<a href='https://www.zerigo.com/docs/apis/dns/1.1' target='_blank'>Introduction and Overview | REST API v1.1 | Managed DNS Documentation | Support | Zerigo</a>

自宅で常時起動しているマシンにサブドメインを割り振ったけど、たまに IP アドレスが変わるので適当に更新しておいてほしい。急がないけどかんたんに済ませたい。という用途にてっとり早く役立った。

```sh
#!/bin/sh

# 新しいのを教えてもらって
ip_address=$(
  curl \
    --basic --user "${ZERIGO_USER_NAME}:${ZERIGO_API_KEY}" \
    http://ns.zerigo.com/api/1.1/tools/public_ipv4.xml \
    | sed -e "s/<\/\?ipv4>//g"
)

# それをそのままお返し
curl \
  --request PUT \
  --header 'Content-Type: application/xml' \
  --data "<host><data>${ip_address}</data></host>" \
  --basic --user "${ZERIGO_USER_NAME}:${ZERIGO_API_KEY}" \
  http://ns.zerigo.com/api/1.1/hosts/${HOST_ID}.xml
```

`HOST_ID` の部分を得るために、次の手順で API に問い合わせた。

* `http://ns.zerigo.com/api/1.1/zones.xml` で目的のゾーンの ID を探す
* `http://ns.zerigo.com/api/1.1/zones/[ゾーンのID]/hosts.xml` で目的のホストの ID を探す

たまに叩くようにしておけばだいたい合ってる。
