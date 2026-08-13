# REL-STORE-01 Android・iOSストアリリース計画書

更新日: 2026/06/16

対象プロジェクト: `itec-denwa` / Denwa / `ぷらっとCALL`

対象範囲: Android / iOS モバイルアプリを Google Play および Apple App Store へ本番公開するためのリリース計画、審査準備、Reviewer向けアカウント、Production API、MVE、SIP Phone連携確認を対象とする。

## 1. 運用方針

- `2026/06/30` は本番公開予定日であり、Store審査開始日ではない。
- Store審査への提出目標日は `2026/06/19`、予備日は `2026/06/22` とする。
- Store審査承認後は、重大な不具合対応が必要な場合を除き、新しいビルドを追加アップロードしない。
- 承認済みビルドは公開可能な状態で保持し、ITECの最終判断後に本番公開する。
- Android / iOS の表示バージョンは `1.0.0` に統一する。
- Android `versionCode` および iOS `build number` は表示バージョンではなく、各Storeの増分ルールに従う。

## 2. 基本情報

### 2.1 アプリおよび環境

| 項目 | 値 | 備考 |
| --- | --- | --- |
| アプリ名 | `ぷらっとCALL` | Android / iOS 共通 |
| プロジェクト | `itec-denwa` | 対象ワークスペース |
| Android本番パッケージ | `jp.co.itec.denwa` | `sources/denwa-android/app/build.gradle.kts` |
| iOS本番Bundle ID | `jp.co.itec.denwa.product` | `Production.xcconfig` |
| Production API | `https://api.apl.purattocall.com` | Android / iOS 本番接続先 |
| Production Web/Admin | `https://apl.purattocall.com` | インフラ設計書に基づく |
| Firebase Android package | `jp.co.itec.denwa` | 本番用 `google-services.json` |
| MVE / SIP Phone | 本番リリースに直接関係あり | ITEC / 岡田電機による設定確認が必要 |

### 2.2 バージョン方針

| プラットフォーム | 表示バージョン | ビルド識別子 | 対応内容 |
| --- | --- | --- | --- |
| Android | `1.0.0` | 既知の `versionCode`: `53` | `VERSION_NAME` を `1.0.0` に合わせ、Google Play Console上の既存アップロードより大きい `VERSION_CODE` を使用する。 |
| iOS | `1.0.0` | 既知の `CURRENT_PROJECT_VERSION`: `19` | `MARKETING_VERSION` は `1.0.0` とし、App Store Connect上の既存ビルドより大きいbuild numberを使用する。 |

注意事項:

- Android `versionCode` に `1.0.0` のような文字列は使用できない。Google Play Consoleでは整数値が必要である。
- iOSのbuild numberはStore内部のビルド識別子であり、表示バージョン `1.0.0` とは別に増分管理する。
- 既にStoreへ高い番号のビルドが登録済みの場合、表示バージョンが `1.0.0` でも、新しい `versionCode` / build number は既存値より大きくする。

### 2.3 参照情報

| 参照元 | 計画で使用する内容 |
| --- | --- |
| `raw/release_wbs_draft_jp_2026-06-10.md` | 2026/06/30 本番公開、審査・公開マイルストーン、ITEC / VTI / 岡田電機の役割 |
| `management/WBS.yaml` | DENWA-WBS-028 から DENWA-WBS-043 までのWBS状況 |
| `knowledge/denwa-android/runbooks/project.md` | Androidビルド条件、private file、JDK 21 |
| `knowledge/denwa-android/runbooks/release-debug.md` | Androidリリース設定と本番挙動 |
| `knowledge/denwa-ios/runbooks/project.md` | iOSプロジェクト、Xcode / CocoaPods、アプリ名、App Store審査注意点 |
| `knowledge/denwa-infra/architecture/ARCH-INFRA-01_インフラ構造設計.md` | Production domain / API routing |
| `knowledge/denwa-infra/runbooks/prd_backend_secret_recovery_2026-06-13.md` | Production API / frontend 状況、secret / DBリスク |
| Apple / Google 公式ドキュメント | Store提出、Reviewer account、App access information |

## 3. リリースWBS

| ID | 分類 | 内容 | 主担当 | 期限 | 現状 | 完了条件 |
| --- | --- | --- | --- | --- | --- | --- |
| DENWA-WBS-028 | Release planning | 6/30リリース範囲およびGo/No-Go条件を確定する | 片山 剛 | 2026/06/12 | Completed | リリース範囲と判断条件が整理済みであること |
| DENWA-WBS-029 | API/Infra | Production APIを準備する | VTI-SAM | 2026/06/12 | Completed | `stg` から `prd` への準備が完了していること |
| DENWA-WBS-030 | API/Infra | Production APIを簡易確認する | VTI-SAM | 2026/06/12 | Completed | API疎通確認が完了していること |
| DENWA-WBS-031 | MVE | MVE本番環境を確認する | 野崎 祐也 | 2026/06/15 | Completed | MVE本番環境がAPI / アプリと連携可能であること |
| DENWA-WBS-032 | SIP Phone | SIP Phone本番環境を準備する | 野崎 祐也 | 2026/06/17 | Awaiting Customer | SIP account、電話番号、tenant、IP Groupが利用可能であること |
| DENWA-WBS-033 | Document | SIP Phone手順をWeb Manualへ追加する | VTI-SAM | 2026/06/17 | Awaiting Customer | Tenant AdminがSIP Phone登録・設定手順を参照できること |
| DENWA-WBS-034 | Integration | Mobile app / API / MVE連携を確認する | VTI-SAM | 2026/06/18 | Awaiting Customer | 発信、着信、push、transfer、終話がPassすること |
| DENWA-WBS-035 | SIP Phone check | SIP Phone本番確認を実施する | 野崎 祐也 | 2026/06/18 | Awaiting Customer | SIP Phoneとmobile間の通話・終話がPassすること |
| DENWA-WBS-036 | UAT/Bugfix | UAT不具合を修正し再確認する | VTI-SAM | 2026/06/18 | In Progress | 重大不具合が解消、またはITECがリリース可否を判断済みであること |
| DENWA-WBS-037 | Store prep | Store提出情報を準備する | VTI-SAM | 2026/06/18 | In Progress | Metadata、screenshot、privacy、review note、test accountが準備済みであること |
| DENWA-WBS-038 | Mobile app | Production接続のRCビルドを作成する | VTI-SAM | 2026/06/19 | In Progress | Android / iOSがインストール可能で、version / signing / production接続が確認済みであること |
| DENWA-WBS-039 | Store review | Store審査へ提出する | VTI-SAM | 2026/06/19 | Open | Appがsubmitted / in reviewの状態であること |
| DENWA-WBS-040 | Hold after approval | 承認後、即時公開せず待機する | VTI-SAM | 2026/06/26 | Open | Store承認済みで、公開可能状態を維持していること |
| DENWA-WBS-041 | Final decision | 公開または延期を判断する | 鈴木 克成 | 2026/06/29 | Open | 書面で公開可否が確定していること |
| DENWA-WBS-042 | Production release | ユーザー向けに本番公開する | 鈴木 克成 | 2026/06/30 | Open | Storeからインストールまたは更新でき、本番スモーク確認が完了していること |
| DENWA-WBS-043 | Monitoring | リリース後監視を行う | VTI-SAM | 2026/07/03 | Open | Crash、API、call、push、reviewの状況を監視し、issue対応方針が明確であること |

## 4. 全体チェックリスト

### 4.1 バージョン確定

- [ ] Android `DenwaVersion.VERSION_NAME` を `1.0.0` に設定する。
- [ ] Android `VERSION_CODE` がGoogle Play Consoleへ過去にアップロード済みの値より大きいことを確認する。
- [ ] Androidのbuild artifact / release noteに旧バージョンやdebug suffixが残っていないことを確認する。
- [ ] iOS targetの `MARKETING_VERSION` が `1.0.0` であることを確認する。
- [ ] iOS `CURRENT_PROJECT_VERSION` / build number がApp Store Connect上の既存値より大きいことを確認する。
- [ ] Google PlayおよびApp Storeの表示バージョンが `1.0.0` であることを確認する。
- [ ] QA / test evidenceは `1.0.0` と紐づく名前で保存し、旧ビルドと混同しないようにする。

### 4.2 RCビルド前提条件

- [ ] `2026/06/30` の本番公開範囲がITECにより確認済みである。
- [ ] リリース対象ticketおよびbugfix一覧が確定している。
- [ ] UAT blockerは解消済み、またはITECが残課題を把握したうえでリリース可否を判断済みである。
- [ ] Production API `https://api.apl.purattocall.com` が利用可能である。
- [ ] Production Web/Admin `https://apl.purattocall.com` が利用可能である。
- [ ] 本番secret / runtime設定が検証環境を参照していないことを確認する。
- [ ] Firebase / APNs / push production設定が確認済みである。
- [ ] MVE本番endpoint、credential、callback、allowlistが岡田電機により確認済みである。
- [ ] SIP Phone本番account、電話番号、tenant、IP GroupがITECまたは岡田電機により確認済みである。
- [ ] Reviewer用test account 3件が作成済みで、主要操作に十分なテストデータを持つ。
- [ ] Reviewer用accountはOTP / 2FA / email verificationで詰まらない。必要な場合は再利用可能な固定OTPを使用できる。

### 4.3 Android build

- [ ] Release対象branch / tag / commitからビルドする。
- [ ] GradleコマンドはJDK 21で実行する。
- [ ] `applicationId = jp.co.itec.denwa` である。
- [ ] 本番アプリ名が `ぷらっとCALL` である。
- [ ] `VERSION_NAME = 1.0.0` である。
- [ ] `VERSION_CODE` が整数かつ増分ルールを満たしている。
- [ ] Release build typeが `env_production.json` を使用する。
- [ ] `APPLICATION_ENDPOINT` および `SOCKET_ENDPOINT` が `https://api.apl.purattocall.com` である。
- [ ] `CALL_PUSH_FCM = true` が本番設定として妥当である。
- [ ] Release signingにproduction keyを使用し、debug / staging keyを使用しない。
- [ ] AAB releaseを正常に作成する。
- [ ] Mapping / Proguard / R8 mappingを保存する。
- [ ] 実機へrelease buildをインストールし、スモークテストを実施する。
- [ ] Login、call、push、transfer、messaging / contactを対象範囲に応じて確認する。
- [ ] Play Console権限に応じてinternal testingまたはproduction draftへアップロードする。

### 4.4 iOS build

- [ ] `Denwa.xcworkspace` を開き、`.xcodeproj` から直接ビルドしない。
- [ ] `Release` configurationと `Production.xcconfig` を使用する。
- [ ] 本番アプリ名が `ぷらっとCALL` である。
- [ ] `APP_BUNDLE_ID = jp.co.itec.denwa.product` である。
- [ ] `ROOT_URL = https://api.apl.purattocall.com` である。
- [ ] `MARKETING_VERSION = 1.0.0` である。
- [ ] `CURRENT_PROJECT_VERSION` / build number が増分ルールを満たしている。
- [ ] Signing、capabilities、provisioning profileがproductionとして有効である。
- [ ] PushKit / APNs / CallKit entitlementがproduction向けに正しく設定されている。
- [ ] Archiveを正常に作成する。
- [ ] App Store Connectへのuploadが正常終了し、build processed状態になる。
- [ ] dSYM / symbolを保存またはcrash toolへアップロードする。
- [ ] TestFlightを使用する場合、RCスモークテストがPassすることを確認する。
- [ ] App Store審査で指摘されたorientation / iPad multitaskingの問題が再発していないことを確認する。

### 4.5 提出前スモークテスト

| ID | テスト | Android | iOS | Pass条件 |
| --- | --- | --- | --- | --- |
| QA-01 | Production RCの新規インストール | [ ] | [ ] | 起動時にcrashしない |
| QA-02 | 旧版からの更新 | [ ] | [ ] | 異常な状態消失がない |
| QA-03 | Account 1ログイン | [ ] | [ ] | ログイン成功 |
| QA-04 | Account 2ログイン | [ ] | [ ] | ログイン成功 |
| QA-05 | Account 3ログイン | [ ] | [ ] | ログイン成功 |
| QA-06 | Tenant / user情報確認 | [ ] | [ ] | test tenantのデータが表示される |
| QA-07 | mobile -> mobile通話 | [ ] | [ ] | 発信・着信・終話が安定する |
| QA-08 | SIP Phone -> mobile通話 | [ ] | [ ] | push / call UIが動作する |
| QA-09 | mobile -> SIP Phone通話 | [ ] | [ ] | 接続および終話ができる |
| QA-10 | Transfer call | [ ] | [ ] | 仕様どおりtransferできる |
| QA-11 | foreground / background / kill時のpush | [ ] | [ ] | blockerがない |
| QA-12 | missed call / voice message | [ ] | [ ] | 対象範囲の場合、通知・ログが正しい |
| QA-13 | chat / message | [ ] | [ ] | 対象範囲の場合、送受信・syncがPassする |
| QA-14 | Logout / re-login | [ ] | [ ] | sessionが安定する |
| QA-15 | camera / mic / photo / notification permission | [ ] | [ ] | promptと挙動が正しい |
| QA-16 | crash / error log | [ ] | [ ] | blocker級crashがない |

## 5. Store提出チェックリスト

### 5.1 Google Play

- [ ] App packageが `jp.co.itec.denwa` である。
- [ ] AAB release `1.0.0` をアップロードする。
- [ ] `versionCode` が過去にアップロード済みの値より大きい。
- [ ] Release notes / changelogが顧客承認済みである。
- [ ] Store listing metadata / screenshot / videoが顧客承認済みである。
- [ ] Privacy Policy URLへアクセスできる。
- [ ] Data safetyがアプリおよびSDKの挙動に合っている。
- [ ] App content / sign-in detailsを入力済みである。
- [ ] Reviewer accountは再利用可能で、期限切れやpassword expirationがない。
- [ ] OTP / 2FAがある場合、reviewer向けにbypassまたは固定OTPを用意する。
- [ ] Content ratingを完了する。
- [ ] Target audience、ads、declarationなど必要項目を完了する。
- [ ] 承認後すぐ公開しない場合、managed publishingまたはmanual rollout方針を確認する。
- [ ] Rollout percentageはITECの判断に従う。

### 5.2 App Store Connect

- [ ] App version `1.0.0` を作成する。
- [ ] アップロード済みの正しいbuildを選択する。
- [ ] App Review Informationにcontact、account、reviewer notesを入力する。
- [ ] Notes for Reviewにloginが必要なことと確認すべきflowを明記する。
- [ ] Screenshot / metadataに未入力のrequired itemがない。
- [ ] Privacy Nutritionが収集・利用データと一致している。
- [ ] Tracking / IDFA / ATT declarationを必要に応じて完了する。
- [ ] Export complianceへの回答を完了する。
- [ ] 承認後に `2026/06/30` まで公開しない場合、manual releaseを選択する。
- [ ] 承認後は重大blockerがない限り新しいbuildをアップロードしない。

## 6. Store reviewer用テストアカウント

Store審査用として、iTECのtenant test `111` に3件の一時アカウントを用意する。Transfer testでは最低3件のactive accountが必要なため、3件を準備対象とする。固定OTPは `123456` とする。

| Account | Platform | Username / Email | Password | Tenant / Role | Fixed OTP | 用途 |
| --- | --- | --- | --- | --- | --- | --- |
| Account 1 | Android / iOS | `account1@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | login / main flow |
| Account 2 | Android / iOS | `account2@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | call / push / transfer |
| Account 3 | Android / iOS | `account3@itec.hankyu-hanshin.co.jp` | `iTec@123456` | Tenant `111` / review account | `123456` | transfer / backup |

確認項目:

- [ ] 3件すべてAndroid RCでログインできる。
- [ ] 3件すべてiOS RCでログインできる。
- [ ] Account lock、password expiration、IP / location制限がない。
- [ ] OTP / 2FA / email verificationは無効化、または固定OTPで通過できる。
- [ ] テストデータに実データや機密情報を含めない。
- [ ] Reviewerがcallを確認する場合に備え、少なくとも2件のaccount間で通話できる。
- [ ] SIP Phone flow確認が必要な場合、関連するSIP Phone / accountを準備する。

## 7. Reviewer notes

### 7.1 App Store Connect - Notes for Review

```text
Hello App Review Team,

This submission is for ぷらっとCALL version 1.0.0, build [BUILD_NUMBER].

The app requires sign-in to access the main VoIP calling and messaging features.

Test environment:
- Please use the production app build submitted in App Store Connect.
- The app connects to the production API environment.

Test accounts:
1. Username: account1@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

2. Username: account2@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

3. Username: account3@itec.hankyu-hanshin.co.jp
   Password: iTec@123456
   Role/Tenant: Tenant ID 111 / temporary review account
   OTP: 123456

Review steps:
1. Launch the app.
2. Sign in with one of the test accounts above.
3. Verify the main screen, contact/user information, and calling features.
4. If needed, use another test account or the prepared SIP Phone test environment to verify call behavior.
5. Sign out from the settings/profile screen after testing.

Notes:
- These accounts are prepared for review only.
- Two-factor authentication, email verification, and SMS verification are disabled for these accounts, or the reusable fixed OTP above can be used.
- Three active accounts are provided because the transfer feature requires at least three accounts for testing.
- No real payment or real personal data is required for review.
- If you need additional information, please contact us through App Store Connect.
```

### 7.2 Google Play Console - App Access Instructions

```text
The app requires sign-in to access its main VoIP calling and messaging features.

Please use one of the following test accounts:

Account 1
- Username: account1@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Account 2
- Username: account2@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Account 3
- Username: account3@itec.hankyu-hanshin.co.jp
- Password: iTec@123456
- Role/Tenant: Tenant ID 111 / temporary review account
- OTP: 123456

Review instructions:
1. Install and open the app.
2. Sign in with one of the test accounts above.
3. Verify the main screen, contact/user information, and calling features.
4. If needed, use another test account or the prepared SIP Phone test environment to verify call behavior.

Additional notes:
- These accounts are for review only.
- The credentials are reusable and do not expire.
- Two-factor authentication, email verification, and SMS verification are disabled for these accounts, or the reusable fixed OTP above can be used.
- Three active accounts are provided because the transfer feature requires at least three accounts for testing.
- No real payment or real personal data is required.
- If access fails, please contact us through Play Console.
```

## 8. ITEC確認依頼事項

リリース候補版のビルドおよびStore審査提出前に、以下をITECへ確認する。

### 8.1 リリース情報

- App: `ぷらっとCALL`
- Android package name: `jp.co.itec.denwa`
- iOS bundle ID: `jp.co.itec.denwa.product`
- Store表示バージョン: `1.0.0`
- Reviewer検証環境: Production
- Production API: `https://api.apl.purattocall.com`
- 審査提出予定日: `2026/06/19`
- 審査提出予備日: `2026/06/22`
- 本番公開予定日: `2026/06/30`
- 推奨公開方式: 承認後すぐ公開しないmanual release / managed publishing

### 8.2 Scope / changelog

- Storeに表示するrelease note / changelogが顧客承認済みであること。
- 6/30公開対象に含める機能と含めない機能が明確であること。
- 残課題がある場合、公開可否判断への影響が明確であること。

### 8.3 Reviewer account

- 3件のreviewer accountがAndroid / iOSの両方でログインできること。
- Fixed OTP `123456` が審査中に利用できること。
- Accountがpassword expiration、account lock、IP制限、メール確認待ちで止まらないこと。
- Reviewerが主要flowを確認できるテストデータが用意されていること。

### 8.4 Production / MVE / SIP Phone

- Production APIが利用可能であること。
- MVE本番endpoint、credential、callback、allowlistが正しく設定されていること。
- SIP Phone本番account、電話番号、tenant、IP Groupが確認可能であること。
- 主な確認flowは発信、着信、push / call、transfer、終話、SIP Phone <-> mobileとする。

### 8.5 Store metadata / privacy

- App name、description、screenshot / videoが承認済みであること。
- Privacy Policy URLが有効であること。
- Google Play Data Safetyが正しいこと。
- App Store Privacy Nutrition / Trackingが正しいこと。
- microphone、notification、contact、photo、camera、locationなどのpermission説明が実装と一致していること。

## 9. 運用タイムライン

| 日付 | マイルストーン | 必要な成果物 |
| --- | --- | --- |
| 2026/06/12 | Scope / Go-No-Go条件、Production API確定 | リリース範囲およびProduction API ready |
| 2026/06/15 | MVE本番確認 | MVE本番がアプリ / APIと連携可能 |
| 2026/06/17 | SIP Phone + manual | SIP Phone本番環境およびTenant Admin向け手順 |
| 2026/06/18 | Integration / UAT / Store prep | 主要flow Pass、metadata / review note / account準備完了 |
| 2026/06/19 | Version 1.0.0 RC + Store提出 | Android / iOS RC、upload、Store提出 |
| 2026/06/22 | 提出予備日 | 6/19に提出できない場合の予備日 |
| 2026/06/26 | Approve-ready | App承認済み、またはreview issue対応中 |
| 2026/06/29 | Final Go/No-Go | ITECが公開または延期を判断 |
| 2026/06/30 | Production release | Google Play / App Storeで本番公開 |
| 2026/07/01 - 2026/07/03 | Monitoring | Crash、error、API、call、push、review状況を監視 |

## 10. 本番公開日チェックリスト

- [ ] Android / iOSともStore審査が承認済みである。
- [ ] 承認後に新しいbuildをアップロードしていない。
- [ ] ITECが `2026/06/30` 公開を文書で承認している。
- [ ] MVE / SIP Phoneに問題が発生した場合、岡田電機 / ITECが確認可能である。
- [ ] VTIがapp / API / logを監視できる。
- [ ] Manual release / managed publishingの手順に従い本番公開する。
- [ ] Store listingに `ぷらっとCALL` version `1.0.0` が表示される。
- [ ] AndroidでStoreから新規インストールまたは更新できる。
- [ ] iOSでStoreから新規インストールまたは更新できる。
- [ ] Test accountでログインできる。
- [ ] 発信、着信、push / callの主要flowを確認する。
- [ ] 公開時刻、version / build、作業者、スモークテスト結果を記録する。

## 11. リリース後監視

| 分類 | 監視内容 | 推奨担当 |
| --- | --- | --- |
| App crash | Crash-free、fatal / non-fatal error | VTI |
| API | Login、tenant / user、call / push API、error rate | VTI |
| MVE / SIP | Register、call、transfer、end call | 岡田電機 / ITEC、VTIはlog確認を支援 |
| Store | Review、rating、reject follow-up | ITEC / VTI |
| Support | User report、issue triage、hotfix / backlog判断 | ITEC / VTI |

Hotfix判断の主な条件:

- Launch、login、callでblocker級crashが発生する。
- Productionでログインできない。
- Push / callが多数端末で動作しない。
- SIP Phone / MVE本番環境がmobileと連携できない。
- Store metadata / privacyに重大な誤りがある。

## 12. 状態報告テンプレート

### 12.1 Store提出後

```text
ぷらっとCALL version 1.0.0 をStore審査へ提出しました。

- Android: version 1.0.0 / versionCode [VERSION_CODE] / status [status]
- iOS: version 1.0.0 / build [BUILD_NUMBER] / status [status]
- 提出日時: [date/time]
- Release mode: manual release / managed publishing

審査状況を継続確認します。Apple / Googleから質問またはrejectがあった場合は、内容を確認して速やかに報告します。
```

### 12.2 Store承認後

```text
ぷらっとCALL version 1.0.0 がStore審査で承認されました。

- Android: [status]
- iOS: [status]

計画どおり、承認直後にはユーザー向け公開を行いません。
2026/06/30の本番公開タイミングについて、最終確認をお願いします。
確認後、公開操作とStore上の簡易確認を実施します。
```

### 12.3 本番公開後

```text
ぷらっとCALL version 1.0.0 を本番公開し、Store上で簡易確認を実施しました。

- Android: [store link/status/rollout %]
- iOS: [store link/status]
- 公開日時: [date/time]
- 簡易確認結果: Storeからインストールまたは更新可能、test accountでログイン可能、主要flowは正常動作

公開後24-72時間はcrash / error / API / call / push / review状況を継続監視します。
```

## 13. 主要リスク

| リスク | 兆候 | 対応方針 |
| --- | --- | --- |
| 表示バージョンが `1.0.0` に揃っていない | Store / build artifactに旧バージョンが残る | source、build artifact、Store draftをupload前に確認する |
| Android `versionCode` が増分されていない | Play Consoleへのuploadが失敗する | 既存upload値を確認してからbuild / uploadする |
| iOS build numberが増分されていない | App Store Connectでbuildを選択できない | 表示バージョンは維持し、build numberのみ増分する |
| Reviewerがログインできない | Storeから問い合わせまたはrejectが来る | 再利用可能なcredentials、fixed OTP、提出前ログイン確認を行う |
| Production API / secretが検証環境を参照している | Reviewerが誤ったデータを見る、またはlogin失敗 | RC前にendpoint、env、secretを確認する |
| MVE / SIP Phoneが未準備 | call / push / transferが失敗する | 岡田電機 / ITECの担当と公開日standbyを決める |
| Privacy / Data Safetyが実装と不一致 | Required actionまたはrejectになる | SDK、permission、data collectionを提出前に照合する |
| 承認後に新buildを追加する | 再審査が必要になる可能性がある | 重大blocker以外では承認済みbuildを維持する |
| Store審査が長期化する | 6/30公開に間に合わない | 早期提出、6/22予備日、審査問い合わせへの当日対応を行う |

## 14. 公式参考資料

- Apple - Submit an app: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app/
- Apple - Overview of submitting for review: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/overview-of-submitting-for-review/
- Google Play - Prepare your app for review: https://support.google.com/googleplay/android-developer/answer/9859455
- Google Play - Requirements for sign-in details: https://support.google.com/googleplay/android-developer/answer/15748846
- Google Play - Data safety section: https://support.google.com/googleplay/android-developer/answer/10787469
