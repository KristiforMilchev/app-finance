[اللغة العربية (AR)](./about_ar.md) |
[Azərbaycanlı (AZ)](./about_az.md) |
[Тарашкевіца (BE)](./about_be.md) |
[Latsinka (BE)](./about_be_EU.md) |
[简体中文 (ZH-CN)](./about_zh.md) |
[繁體中文 (ZH-TW)](./about_zh_TW.md) |
[English (EN-US)](./about_en.md) |
[Français (FR)](./about_fr.md) |
[Deutsch (DE)](./about_de.md) |
[हिंदी (HI-IN)](./about_hi.md) |
[Italiano (IT)](./about_it.md) |
日本語 (JA) |
[فارسی (FA)](./about_fa.md) |
[Polski (PL)](./about_pl.md) |
[Português Europeu (PT)](./about_pt.md) |
[Português Brasileiro (PTB)](./about_pt_BR.md) |
[Español (ES)](./about_es.md) |
[Türk dili (TR)](./about_tr.md) |
[Українська (UK-UA)](./about_uk.md) |
[O'zbek (UZ)](./about_uz.md)

---

**Fingrom** オープンソースのクロスプラットフォーム財務会計アプリケーション。
このソリューションの目標は、直感的、効率的、包括的な財務会計アプリケーションを作成することです。
これにより、誰もが取り残されることなく、ユーザーが簡単に財務を管理できるようになります。

[![ビデオを見る](../images/presentation_en.png)](https://youtu.be/sNTbpILLsOw)

### 機能
- 会計（口座タイプ、通貨/暗号通貨）
  - メインページの`/`シンボル(名前)によるシンプルなグループ化
  - 取引ログ
  - 更新日による金額の凍結（過去の履歴のインポート）
- 予算カテゴリー
  - メインページの`/`-シンボル(名前)によるシンプルなグループ化
  - 限度額の再設定
    - 毎月月初に更新
    - 月ごとに設定可能な限度額
    - 収入との関係 (0.0 ... 1.0)
  - または、使用済み金額を表示することにより制限なし
- 請求書、振込、収入（請求書）
- 目標の定義
- 為替レート、サマリーのデフォルト通貨
- 指標 
  - 予算
    - 予測（モンテカルロ・シミュレーションを使用）
    - 月ごとの予算上限と支出
  - 口座
    - ローソク足（OHLC）チャート
    - 収入の健康レーダー
    - 通貨分布
  - 手形
    - YTD支出
    - カテゴリー別バーレース
  - 目標ゲージチャート
  - 通貨ヒストリカルチャート
- デバイス間の同期（P2P） 
- WebDavまたは直接ファイルを介したリカバリ
- CSVファイル、QIFファイル、OFXファイルから請求書や請求書をインポート
- データの暗号化
- ローカライゼーション
- ユーザーエクスペリエンス
  - 設定可能なメインページ（幅×高さのセットごとに複数の設定が可能）
  - レスポンシブ＆アダプティブデザイン
    - アダプティブ・ナビゲーション・パネル（上、下、右）とタブ（上、左）
  - テーマモード(ダーク、ライト、システム)とパレット定義(システム、カスタム、パーソナル -- カラーセレクター)
  - アカウント、予算、通貨の最後の選択を保持
  - フォーム上でフォーカスされた要素への自動スクロール
  - メインページでのセクションの展開/折りたたみ
  - スワイプによる編集と削除アクションへのクイックアクセス
  - 設定 "からズームイン/ズームアウト(60%から200%まで)
  - ショートカット

| 説明                                | ショートカット                   |
| ----------------------------------- | ------------------------------ |
| ナビゲーション ドロワーを開く / 閉じる | `Shift` + `Enter`              |
| 上へ移動                             | `上`                           |
| 下へ移動                             | `ダウン`                       |
| 選択した項目を開く                    | `Enter`                       |
| ズームイン                           | `Ctrl` + `+`                   |
| ズームイン (マウス使用)               | `Ctrl` + `スクロールダウン`     |
| ズームアウト                         | `Ctrl` + `-`                   |
| ズームアウト (マウス使用)             | `Ctrl` + `上にスクロール`       |
| ズームをリセット                      | `Ctrl` + `0`                  |
| 新しいトランザクションを追加           | `Ctrl` + `N`                  |
| 戻る                                | `Ctrl` + `Backspace`           |
<!--
| 選択した項目を編集                   | `Ctrl` + `E`                   |
| 選択した項目を削除                   | `Ctrl` + `D`                   |
-->
