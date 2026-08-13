# TC-IT-API-02 VoIPWebAPI結合テストカバレッジ

## 1. 目的

本書は、VoIP Web管理機能の受入テスト観点を、API結合テストとしてどの範囲まで確認しているかを整理するカバレッジ資料である。

画面操作そのものを検証するUIテストではなく、Backend API、DB初期化、mail / OTP capture、MVE stub、file response確認により、業務結果および主要な異常系を確認する。

## 2. 対象資料および実行結果

| 項目 | 内容 |
| --- | --- |
| 元テストケース | `UAT_VoIP電話ウェブ側テストケース.xlsx` |
| 受入テストMarkdown | `project-store/artifacts/reports/testcases/TC-UAT-WEB-01_VoIPWeb受入テストケース/TC-UAT-WEB-01_VoIPWeb受入テストケース.md` |
| 自動化判定表 | `project-store/artifacts/reports/testcases/TC-IT-API-03_VoIPWebAPI自動化判定/TC-IT-API-03_VoIPWebAPI自動化判定.md` |
| API結合テスト文書 | `project-store/artifacts/reports/testcases/TC-IT-API-01_VoIPWebAPI結合テスト/TC-IT-API-01_VoIPWebAPI結合テストケース.md` |
| 実行対象 | `VoipWebApiRegressionIT`, `AuthApiIT`, `AuthIpWhitelistDeniedIT` |
| 直近実行結果 | `110 tests`, `0 failures`, `0 errors`, `0 skipped` |
| 実行環境 | ローカルAPI結合テスト環境、Testcontainers PostgreSQL、stub連携 |

## 3. 変換方針

| 元のUIテスト観点 | API結合テストでの確認方法 |
| --- | --- |
| 画面遷移、button click、form入力 | 対応するBackend APIを呼び出し、HTTP statusとresponseを確認する。 |
| 一覧、詳細、検索結果の表示 | `200 OK` とpayload JSON / byte response内の主要データを確認する。 |
| 入力validationエラー | APIが `4xx` を返し、server errorにならないことを確認する。 |
| Server error防止 | 主要flowで `5xx` が返らないことを確認する。 |
| OTP / mail送信 | test mail capture、DB上のOTP、送信flagを確認する。 |
| MVE連携 | fake / stub MVE serverを利用し、API側の処理結果を確認する。 |
| CSV / file download | byte response、file名、主要headerまたはerror file名を確認する。 |
| テストデータ前提 | 各case前にDBを初期化し、fixtureを再投入する。 |

## 4. Coverage分類

| 分類 | 意味 |
| --- | --- |
| `equivalent` | 元のテスト観点とほぼ同等の業務結果をAPI結合テストで確認している。 |
| `api-equivalent` | UI操作はAPI callに置き換えているが、業務結果またはAPI contractは同等に確認している。 |
| `negative-equivalent` | 異常系を該当APIのエラー応答として確認している。 |
| `smoke` | endpointまたは主要flowが正常応答することを確認している。 |
| `partial` | 業務意図の一部のみ確認しており、UI表示、mail本文、MVE実機、mobile side effectなどは未確認である。 |

## 5. 件数サマリー

| グループ | 件数 | 主な確認内容 | 評価 |
| --- | ---: | --- | --- |
| Web受入テスト由来のAPI変換case | 104 | 受入テストのRole / TC IDを保持し、API・DB・stubで確認可能な範囲へ変換 | 多くは `api-equivalent`、UI表示系は `partial` |
| 認証・IP whitelist guard case | 6 | `AuthApiIT` / `AuthIpWhitelistDeniedIT` による認証、multi-role、IP whitelistの保護 | `api-equivalent` |
| 合計 | 110 | ローカルAPI結合テストsuite | 直近実行で全件Pass |

## 6. 機能別カバレッジ

| 領域 | 現在の確認内容 | 残るgap |
| --- | --- | --- |
| 認証 / IP whitelist | token発行、OTP、password変更・再設定、5回失敗lock、multi-role選択、IP whitelist denyを確認している。 | UI上のエラーメッセージ文言や画面遷移は確認対象外である。 |
| Tenant管理 | tenant作成、検索、詳細、更新、停止、再有効化、削除、tenant admin mail送信をAPIで確認している。 | button表示制御、dialog、画面上の完全な項目表示は未確認である。 |
| CSV import / export | template download、CSV upload成功、invalid file、bad header、error file名、byte responseを確認している。 | すべてのCSV列値、全validation message、50MB超実ファイルは未確認である。 |
| User管理 | user一覧、検索、追加、更新、削除、有効化mail送信、状態別検索を確認している。 | UI button state、mail本文の完全一致、mobile側ログイン状態は未確認である。 |
| MVE / maintenance | maintenance開始・終了・状態確認、account export、IPGroup通知を確認している。 | MVE実機import、SIP削除の外部反映、mobile通話・message無効化の実機挙動は未確認である。 |
| Onboarding | tenant、user、mail、activationに関係するAPIのsmoke flowを確認している。 | tenant作成からmobile初回ログインまでの完全なE2Eは未確認である。 |
| Store reviewer関連 | test account前提、OTP、login周辺APIを確認している。 | Store審査端末上の実UI操作は別途手動確認が必要である。 |

## 7. 代表的なAPI結合テスト観点

| No | 領域 | 代表method | 確認観点 | Coverage |
| ---: | --- | --- | --- | --- |
| 1 | 認証 | `systemAdminLoginOk` | System admin loginでaccess tokenが発行される。 | `api-equivalent` |
| 2 | 認証 | `systemAdminIpDenied` | whitelist外IPではsystem admin loginが `401 Unauthorized` になる。 | `equivalent` |
| 3 | 認証 | `tenantAdminOtpLoginOk` | Tenant admin login、preToken、OTP確認、access token発行を確認する。 | `api-equivalent` |
| 4 | 認証 | `tenantAdminWrongOtpLockRejected` | OTPを5回連続で誤入力した場合のlock / reject挙動を確認する。 | `api-equivalent` |
| 5 | Tenant管理 | `tenantCreateFixedPhoneOk` | 固定電話ありtenantの作成とadmin mapping作成を確認する。 | `api-equivalent` |
| 6 | Tenant管理 | `tenantDeleteOk` | tenant削除後、対象tenant admin loginがrejectされることを確認する。 | `api-equivalent` |
| 7 | CSV | `tenantCsvValidUploadOk` | 有効CSV uploadによりuserとaccount mappingが作成される。 | `api-equivalent` |
| 8 | CSV | `usersCsvInvalidDataRejectedWithErrorFile` | 不正CSVで `4xx` とerror file名が返ることを確認する。 | `partial` |
| 9 | User管理 | `userAddOk` | 新規user追加とaccount mapping作成を確認する。 | `api-equivalent` |
| 10 | User管理 | `sendActiveMailOk` | 有効化mail送信とstatus更新を確認する。 | `api-equivalent` |
| 11 | MVE | `mveNotifyIpGroupOk` | IPGroup作成完了通知APIが正常応答する。 | `api-equivalent` |
| 12 | Maintenance | `mveStartAndCheckMaintainOk` | maintenance開始後、状態確認APIがmaintenance中を返す。 | `partial` |
| 13 | Account export | `mveExportAccountOk` | SIP account CSV export APIが正常応答する。 | `api-equivalent` |
| 14 | Onboarding | `onboardingTenantMailFlowOk` | onboarding関連APIの主要flowが正常応答する。 | `partial` |
| 15 | Guard | `multiRoleMasterSelectionReturnsUnauthorizedWhenIpIsNotWhitelisted` | multi-role master選択時もwhitelist外IPを拒否する。 | `api-equivalent` |

## 8. 手動確認が必要な領域

API結合テストでは確認できない、または意図的に範囲外としている確認項目は以下である。

- 画面DOM、button表示 / 非表示、dialog、browser navigation。
- UI上の日本語メッセージ文言の完全一致。
- 実機MVEへのCSV import結果、およびSIP account削除の外部反映。
- mobile app側のcall、push、message、transfer、background / kill状態の挙動。
- Store reviewer端末上での実ログインとStore審査用動線。
- 50MB超など、ローカルAPI harnessで安定実行しにくい巨大fileの実サイズ検証。

## 9. 改善優先度

| 優先度 | 対象 | 追加するとよい確認 |
| --- | --- | --- |
| 高 | 認証 / OTP / lock | 5回失敗後のlock解除条件、resend挙動、UI表示文言との対応確認 |
| 高 | CSV import / export | error file内容、CSV header全列、文字コード、巨大file boundary |
| 高 | MVE / maintenance | 実MVE import、SIP削除、maintenance中のmobile call / message抑止 |
| 中 | Tenant / User管理 | UI button state、一覧絞り込み結果の全row検証 |
| 中 | Onboarding | tenant作成からactivation、mobile初回loginまでのE2E |
| 中 | Store reviewer | reviewer accountでの実機手動スモーク証跡 |

## 10. 結論

現在のAPI結合テストsuiteは、Web受入テスト由来の104件と認証・IP whitelist guard 6件を合わせた110件で構成されている。直近のローカル実行では全件Passしており、Backend API、DB更新、OTP / mail capture、CSV、MVE stubを用いた主要な業務結果確認としては有効である。

一方で、本suiteはUI automationではないため、画面表示、button state、実機MVE、mobile app挙動、Store reviewer端末での操作は置き換え対象外である。これらは手動IT evidence、UAT evidence、または別途UI / mobile automationで補完する。
