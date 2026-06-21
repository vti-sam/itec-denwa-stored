# REL-DEPLOY-01 アプリデプロイチェックリスト

## 基本情報

| 項目 | 内容 |
| --- | --- |
| 文書名 | アプリ本番デプロイチェックリスト |
| 関連資料 | REL-STORE-01_Android・iOSストアリリース計画_リリース計画書.md |
| 対象範囲 | ぷらっとCALL Android / iOS 本番リリース |
| バージョン | 1.0.0 |
| 作成者 | VTI-SAM |
| 作成日 | 2026/06/19 |

## 改訂履歴

| バージョン | 依頼者 | 更新者 | 更新日 | 変更理由 | シート名 | 更新内容 |
| --- | --- | --- | --- | --- | --- | --- |
| 1.0.0 | ITEC | VTI-SAM | 2026/06/19 | 新規作成 | Android, iOS | 本番リリース用チェックリストおよび証跡取得観点を作成 |

## 記録ルール

- 各項目について、実施状況、担当者、確認者、証跡を記録する。
- `必須証跡` と記載された項目は、画面キャプチャ、ログ、設定差分、Store画面などの確認証跡が揃ってからPassとする。
- バージョンおよびbuild識別子は、変更前と変更後の両方を記録する。
- 初回本番公開の表示バージョンは `1.0.0` とする。Android `versionCode` および iOS build number は各Storeの増分ルールに従う。
- Store上に既存buildがある場合、build識別子を `1` に戻さず、Storeが要求する次の番号を使用する。
- password、signing key、token、secretはチェックリストや証跡に記載しない。必要な場合は伏せ字または権限制御された保管場所を参照する。

## Checklist {sheet=Android}

### A. ビルド前確認

- [ ] ITECがリリース範囲と本番公開予定日を確認済みである。 **証跡:** 確認済みの文書、メール、またはチャット記録
- [ ] 未解決のblocker ticketがない、またはITECが残課題を把握したうえでリリース可否を判断済みである。 **証跡:** ticket一覧または承認記録
- [ ] Production API `https://api.apl.purattocall.com` およびWeb `https://apl.purattocall.com` にアクセスできる。 **証跡:** 時刻付きの疎通結果または画面キャプチャ
- [ ] MVE / SIP Phone本番環境がスモークテストに利用できる。 **証跡:** ITECまたは岡田電機の確認記録
- [ ] Reviewer accountでログインでき、OTP / 2FAにより審査が止まらない。 **証跡:** 機密情報を伏せたログイン成功画面
- [ ] Release対象branch / tag / commitが確定しており、作業treeに範囲外変更がない。 **証跡:** commit SHAおよびGit確認ログ

### B. バージョンおよび本番設定

- [ ] 変更前の表示バージョンおよび `versionCode` を記録する。 **必須証跡:** 変更前のsource / config画面
- [ ] 本番パッケージがGoogle Play Consoleへ過去にアップロード済みか確認する。 **必須証跡:** package名と確認時刻が分かるPlay Console画面
- [ ] 既知のsource baselineとして `versionCode 53` を確認する。source実値が異なる場合は実値と理由を記録する。 **証跡:** source reference
- [ ] 表示バージョンを `1.0.0` に設定し、debug / staging suffixや旧バージョンが残っていないことを確認する。 **必須証跡:** 変更後のsource / config画面
- [ ] `versionCode` がGoogle Play Consoleの既存buildより大きいことを確認する。 **必須証跡:** 変更後sourceおよびPlay Consoleの比較結果
- [ ] 本番パッケージが `jp.co.itec.denwa` である。 **証跡:** Gradle / manifestまたはpackage inspection結果
- [ ] 本番アプリ名が `ぷらっとCALL` である。 **証跡:** configおよび実機画面
- [ ] Production config、Production APIを使用し、検証環境endpointを参照していない。 **必須証跡:** secretを伏せたconfig差分
- [ ] `CALL_PUSH_FCM` およびpush production設定がリリース計画と一致している。 **証跡:** secretを伏せたconfig差分
- [ ] JDKおよびbuild toolのバージョンがプロジェクト要件を満たしている。 **証跡:** version log
- [ ] 最終diffを確認し、credentialやprivate fileが含まれていない。 **証跡:** review記録またはcommit SHA

### C. ビルドおよび署名

- [ ] Clean build releaseが正常終了する。 **必須証跡:** 成功終了したbuild log
- [ ] Production signing configで署名され、debug keyを使用していない。 **証跡:** 機密情報を伏せたsigning verification結果
- [ ] 本番AABが作成される。 **必須証跡:** path、filename、size、SHA-256 checksum
- [ ] AABのpackage、version name、versionCodeが正しい。 **必須証跡:** bundle inspection結果
- [ ] AAB / mapping file / checksumを管理場所に保存する。 **証跡:** pathおよびchecksum
- [ ] Android実機にRCをインストールし、起動時crashがない。 **必須証跡:** app画面、端末情報、OS情報
- [ ] App / About画面がある場合、version `1.0.0` が表示される。 **必須証跡:** 実機画面
- [ ] 本番アプリ内に検証環境endpoint、banner、labelが表示されない。 **証跡:** 確認画面

### D. Androidスモークテスト

- [ ] 本番RCを新規インストールできる。 **証跡:** 画面または短い動画
- [ ] 旧版から本番RCへ更新でき、保持すべきデータが維持される。 **証跡:** 更新前後の画面
- [ ] Test accountでログインできる。 **必須証跡:** 機密情報を伏せたログイン後画面
- [ ] Tenant、user、roleが正しく表示される。 **証跡:** 画面
- [ ] mobile-to-mobile通話が成功し、双方向音声が安定する。 **証跡:** 画面、動画、またはcall log
- [ ] SIP Phone-to-mobile通話が成功する。 **証跡:** 画面、動画、またはcall log
- [ ] mobile-to-SIP Phone通話が成功する。 **証跡:** 画面、動画、またはcall log
- [ ] foregroundで着信およびcall UIが動作する。 **証跡:** 画面または動画
- [ ] backgroundで着信およびcall UIが動作する。 **証跡:** 画面または動画
- [ ] app kill状態で着信およびcall UIが動作する。 **必須証跡:** 画面または動画、push / call log
- [ ] Transfer callが仕様どおり動作する。 **証跡:** 画面、動画、またはcall log
- [ ] 対象範囲に含まれる場合、message / contact flowがPassする。 **証跡:** 結果画面、対象外の場合はN/A理由
- [ ] スモークテスト中にcrash、ANR、blocker errorがない。 **証跡:** logまたはcrash dashboard
- [ ] 端末、Android OS、ネットワーク、テスト時刻を記録する。 **証跡:** test record

### E. Google Play審査および公開

- [ ] 本番AABをGoogle Play Consoleへアップロードする。 **必須証跡:** artifact / versionCodeが分かるupload後画面
- [ ] Play Console上のversion nameおよびversionCodeが正しく、blocker errorがない。 **必須証跡:** Console画面
- [ ] Store listing、screenshot、release noteが顧客承認済みである。 **証跡:** 承認記録またはリンク
- [ ] Data safety、App content、target API、policy declarationを入力済みである。 **証跡:** Console状態画面
- [ ] Reviewer accountおよびreview noteを入力済みで、passwordをチェックリストへ記載していない。 **証跡:** credentialを伏せた入力画面
- [ ] 承認後すぐ公開しない場合、managed publishingまたはmanual release設定を確認する。 **証跡:** 設定画面
- [ ] 審査提出が完了し、提出時刻を記録する。 **必須証跡:** review status画面
- [ ] 承認後、重大blockerがない限り新しいbuildを追加アップロードしない。 **証跡:** release owner確認
- [ ] ITECが本番公開時刻を文書で承認する。 **必須証跡:** メール、チャット、または承認記録
- [ ] 本番公開し、作業時刻と作業者を記録する。 **必須証跡:** production status画面
- [ ] Storeに `ぷらっとCALL` version `1.0.0` が表示される。 **必須証跡:** Store画面
- [ ] Google Playから新規インストールまたは更新できる。 **証跡:** 実機画面
- [ ] 公開後にlogin、call、pushの主要flowがPassする。 **必須証跡:** smoke-test record
- [ ] 公開後のAPI、log、crashを監視し、monitor期間内にblockerがない。 **証跡:** dashboard / log summary
- [ ] AAB、mapping、checksum、commit / tag、release recordを管理場所へ保存する。 **証跡:** artifact pathまたはリンク

## Checklist {sheet=iOS}

### A. ビルド前確認

- [ ] ITECがリリース範囲と本番公開予定日を確認済みである。 **証跡:** 確認済みの文書、メール、またはチャット記録
- [ ] 未解決のblocker ticketがない、またはITECが残課題を把握したうえでリリース可否を判断済みである。 **証跡:** ticket一覧または承認記録
- [ ] Production API `https://api.apl.purattocall.com` およびWeb `https://apl.purattocall.com` にアクセスできる。 **証跡:** 時刻付きの疎通結果または画面キャプチャ
- [ ] MVE / SIP Phone本番環境がスモークテストに利用できる。 **証跡:** ITECまたは岡田電機の確認記録
- [ ] Reviewer accountでログインでき、OTP / 2FAにより審査が止まらない。 **証跡:** 機密情報を伏せたログイン成功画面
- [ ] Release対象branch / tag / commitが確定しており、作業treeに範囲外変更がない。 **証跡:** commit SHAおよびGit確認ログ

### B. バージョンおよび本番設定

- [ ] 変更前の `MARKETING_VERSION` および `CURRENT_PROJECT_VERSION` を記録する。 **必須証跡:** 変更前のproject setting / source画面
- [ ] 本番Bundle IDがApp Store Connectへ過去にアップロード済みか確認する。 **必須証跡:** Bundle IDと確認時刻が分かるApp Store Connect画面
- [ ] 既知のsource baselineとしてbuild `19` を確認する。source実値が異なる場合は実値と理由を記録する。 **証跡:** source reference
- [ ] 表示バージョン `MARKETING_VERSION` を `1.0.0` に設定し、debug / staging suffixや旧バージョンが残っていないことを確認する。 **必須証跡:** 変更後のproject setting / source画面
- [ ] build number `CURRENT_PROJECT_VERSION` がApp Store Connectの既存buildより大きいことを確認する。 **必須証跡:** 変更後sourceおよびApp Store Connectの比較結果
- [ ] `Denwa.xcworkspace` からビルドし、projectを直接ビルドしていない。 **証跡:** Xcode workspace / scheme画面
- [ ] 本番Bundle IDが `jp.co.itec.denwa.product` である。 **証跡:** signing / build setting画面
- [ ] 本番アプリ名が `ぷらっとCALL` である。 **証跡:** configおよびHome Screen
- [ ] Release scheme / configurationが `Production.xcconfig` とProduction APIを使用している。 **必須証跡:** secretを伏せたscheme / build setting画面
- [ ] Push Notifications、Background Modes、PushKit / APNs / CallKit capabilitiesがproductionとして有効である。 **証跡:** Signing & Capabilities画面
- [ ] Orientation / device supportが承認済みの範囲と一致し、過去の審査指摘が再発していない。 **証跡:** setting / test画面
- [ ] 最終diffを確認し、credentialやprivate fileが含まれていない。 **証跡:** review記録またはcommit SHA

### C. Archive、署名、upload

- [ ] Clean build Releaseが正常終了する。 **必須証跡:** 成功終了したbuild log
- [ ] Signing certificate、provisioning profile、Team、entitlementsがproductionとして有効である。 **証跡:** 機密情報を伏せたsigning validation結果
- [ ] 正しいworkspace / scheme / configurationからArchiveを作成する。 **必須証跡:** version / build / 時刻が分かるOrganizer画面
- [ ] Validate Appが正常終了し、blocker errorがない。 **必須証跡:** validation result
- [ ] App Store Connectへのuploadが正常終了する。 **必須証跡:** version / buildが分かるupload result
- [ ] App Store Connect上でbuild processingが完了する。 **必須証跡:** processed build画面
- [ ] 対象archive / buildに対応するdSYM / symbolを保存する。 **証跡:** pathおよびchecksum
- [ ] TestFlightまたはAd HocでiPhone実機にRCをインストールし、起動時crashがない。 **必須証跡:** app画面、端末情報、iOS情報
- [ ] App / About画面がある場合、version `1.0.0` が表示される。 **必須証跡:** 実機画面
- [ ] 本番アプリ内に検証環境endpoint、banner、labelが表示されない。 **証跡:** 確認画面

### D. iOSスモークテスト

- [ ] 本番RCを新規インストールできる。 **証跡:** 画面または短い動画
- [ ] 旧版から本番RCへ更新でき、保持すべきデータが維持される。 **証跡:** 更新前後の画面
- [ ] Test accountでログインできる。 **必須証跡:** 機密情報を伏せたログイン後画面
- [ ] Tenant、user、roleが正しく表示される。 **証跡:** 画面
- [ ] mobile-to-mobile通話が成功し、双方向音声が安定する。 **証跡:** 画面、動画、またはcall log
- [ ] SIP Phone-to-mobile通話が成功する。 **証跡:** 画面、動画、またはcall log
- [ ] mobile-to-SIP Phone通話が成功する。 **証跡:** 画面、動画、またはcall log
- [ ] foregroundで着信およびCallKit UIが動作する。 **証跡:** 画面または動画
- [ ] backgroundで着信およびCallKit UIが動作する。 **証跡:** 画面または動画
- [ ] app kill状態で着信およびCallKit UIが動作する。 **必須証跡:** 画面または動画、push / call log
- [ ] Transfer callが仕様どおり動作する。 **証跡:** 画面、動画、またはcall log
- [ ] 対象範囲に含まれる場合、message / contact flowがPassする。 **証跡:** 結果画面、対象外の場合はN/A理由
- [ ] スモークテスト中にcrashまたはblocker errorがない。 **証跡:** logまたはcrash dashboard
- [ ] 端末、iOS version、ネットワーク、テスト時刻を記録する。 **証跡:** test record

### E. App Store審査および公開

- [ ] App Store Connectで正しいprocessed build `1.0.0` を選択する。 **必須証跡:** 選択済みversion / build画面
- [ ] Store listing、screenshot、release noteが顧客承認済みである。 **証跡:** 承認記録またはリンク
- [ ] Privacy、App content、export compliance、policy declarationを入力済みである。 **証跡:** App Store Connect状態画面
- [ ] Reviewer accountおよびreview noteを入力済みで、passwordをチェックリストへ記載していない。 **証跡:** credentialを伏せた入力画面
- [ ] 承認後すぐ公開しない場合、manual release設定を確認する。 **証跡:** 設定画面
- [ ] 審査提出が完了し、提出時刻を記録する。 **必須証跡:** review status画面
- [ ] 承認後、重大blockerがない限り新しいbuildを追加アップロードしない。 **証跡:** release owner確認
- [ ] ITECが本番公開時刻を文書で承認する。 **必須証跡:** メール、チャット、または承認記録
- [ ] 本番公開し、作業時刻と作業者を記録する。 **必須証跡:** Ready for Distribution / production status画面
- [ ] App Storeに `ぷらっとCALL` version `1.0.0` が表示される。 **必須証跡:** Store画面
- [ ] App Storeから新規インストールまたは更新できる。 **証跡:** 実機画面
- [ ] 公開後にlogin、call、pushの主要flowがPassする。 **必須証跡:** smoke-test record
- [ ] 公開後のAPI、log、crashを監視し、monitor期間内にblockerがない。 **証跡:** dashboard / log summary
- [ ] archive、dSYM、checksum、commit / tag、release recordを管理場所へ保存する。 **証跡:** artifact pathまたはリンク
