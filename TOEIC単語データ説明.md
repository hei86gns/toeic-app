# TOEIC単語データ説明

調査日：2026-07-26（Content Managerアプリの開発中に調査）

## 今アプリに入っているもの

`yuliaToeic_v1.html` 内の `BUILTIN_VOCAB` 定数：

- **1,258語**（TSL由来・CC BY-SA 4.0由来・独自日本語訳）
- 元データは `toeic_tsl_full_tangocho.json`（Content Managerでは `data/words/toeic_tsl.json` としてコピーを管理）

## まだアプリに入っていない候補データ

`~/Desktop/TOEIC_app/Contents/toeic_vocab.csv`（4,059語、NGSL基準）に、難易度別の分類がすでに入っている。

| tier | 語数 | band | 内容 | 日本語訳(jp列) |
|---|---|---|---|---|
| TOEIC | 1,258語 | (空欄) | 今アプリに入っている分と一致 | 1,258語すべて埋まっている |
| T1 | 1,000語 | 1000 | 最頻出レベル | 6語のみ（ほぼ空） |
| T2 | 1,000語 | 2000 | 中間レベル | 10語のみ（ほぼ空） |
| T3 | 801語 | 3000 | **一番レベルが高い** | 13語のみ（ほぼ空） |

CSVの列構成：`word, source, band, tier, in_tangocho, jp`

- `source`：NGSL（New General Service List）が出典
- `in_tangocho`：tangochoの単語帳に既に存在するかのフラグ（41語がフラグ済み。「二重に覚える必要があるか」の目印になりそう）
- `jp`：日本語訳。T1/T2/T3はほとんど未記入 → **アプリに追加する前に日本語訳を用意する作業が必要**

## 「ハイレベルなセット」を追加する場合の想定手順

1. `toeic_vocab.csv` の対象tier（例：T3の801語）を `{w, m}` 形式のJSONに変換
2. Content Managerの `data/words/` に新しいファイルとして配置（例：`toeic_advanced.json`）
3. Content Manager上で開き、日本語訳が空の単語をインライン編集で埋める。不要な単語は削除、タグ付けで整理
4. 「埋め込み用JSONをダウンロード」で `{w, m}` だけの配列を書き出す
5. Claude Codeに依頼して `yuliaToeic_v1.html` に新しい定数（例：`BUILTIN_VOCAB_ADVANCED`）として追加
6. **注意**：`yuliaToeic_v1.html` は現状 `BUILTIN_VOCAB` という単一のリストしか持っておらず、「レベルを選んで学習する」という仕組み自体がまだアプリ側にない。レベル別セットを実際に選べるようにするには、Content Managerの範囲外で、TOEICアプリ側の設計・実装が別途必要になる。

## 今後の方針（Noriの意向）

いずれT1・T2・T3の全レベルを作り、アプリに組み込みたい。まずはT3（ハイレベル、801語）から着手する案が出ている。日本語訳の下書きはClaude Codeが用意することも可能（その後Content Manager上で確認・修正する運用）。
