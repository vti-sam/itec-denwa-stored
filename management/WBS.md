---
schema_version: 3
table: wbs
key: id
mode: replace
---

# 作業計画 / WBS

| id | customer_task_id | vti_backlog_id | type | title | description | owner | start_date | end_date | deadline | status | priority | definition_of_done | risk_id | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DENWA-WBS-001 |  | ITEC_DENWA_APP-138 | Task | Backlogの状況更新 | Backlogの各課題を実際の進捗に合わせて更新する。 | VTI_SAM | 2026-05-26 | 2026-05-26 | 2026-05-29 | Completed | High | 完了・対応中・顧客確認待ちを正しく反映し、完了内容をコメントで共有する。 |  | VOIP_APL-186は片山様、その他は鈴木様へ確認を依頼する。 |
| DENWA-WBS-002 |  | ITEC_DENWA_APP-139 | Scope item | 「途中経過報告」への回答資料作成 | 途中経過報告の残課題・提案に対する対応状況と結果を整理する。 | VTI_SAM | 2026-05-26 |  | 2026-05-29 | Completed | High | 提出資料で対応内容、結果、残確認事項を確認できる。 |  | 合意済み範囲のみ記載する。 |
| DENWA-WBS-004 |  | ITEC_DENWA_APP-140 | Bug fix | iPhone SEの画面下部ボタン表示崩れ修正 | iPhone SEの画面下部ボタンのレイアウト不具合を修正する。 | VTI_SAM | 2026-05-26 | 2026-05-26 | 2026-05-29 | Completed | High | ボタン表示崩れを修正し、バージョン1.0.0 (15)でリリースする。 |  | 修正・リリース済み。 |
| DENWA-WBS-005 |  | ITEC_DENWA_APP-141 | Dependency | セキュリティ確認とソースレビュー準備 | セキュリティ確認項目を整理し、ソースレビューに必要な資料とアクセスを準備する。 | VTI_SAM | 2026-05-26 |  | 2026-05-27 | Completed | High | 確認資料とレビュー環境の準備が完了している。Secrets Managerは単一JSON secret、ECS Task Definitionの環境変数マッピング、Spring Bootの@Value利用、APNS/SSL Keystore (.p8/.p12)のファイル復元を確認する。 |  | グローバルIPとアクセス手続きを顧客に確認する。 |
| DENWA-WBS-006 |  | ITEC_DENWA_APP-136 | Scope item | ユーザー管理のテナント統合確認 | User Managementでmobile tenantとSIPP tenantを論理的に統合できるか確認する。 | VTI_SAM | 2026-05-26 |  | 2026-05-29 | Completed | High | 論理テナント表示と物理tenant/schemaへのルーティング方針を確認する。 |  | 影響範囲はUser Managementに限定して顧客確認する。 |
| DENWA-WBS-008 |  | ITEC_DENWA_APP-142 | Bug fix | Androidの残課題対応 | Android関連課題を調査・修正し、動作を確認する。 | VTI_SAM | 2026-05-26 |  | 2026-05-29 | Completed | High | 対象不具合の修正、動作確認、Backlog更新が完了している。 |  | Transfer連続操作はサンプルアプリも確認する。 |
| DENWA-WBS-009 |  | ITEC_DENWA_APP-143 | Bug fix | iOSの残課題対応 | iOS関連課題を調査・修正し、動作を確認する。 | VTI_SAM | 2026-05-26 |  | 2026-05-29 | Completed | High | 対象不具合の修正、動作確認、Backlog更新が完了している。 |  | iOS課題を優先して対応する。 |
| DENWA-WBS-012 | VOIP_APL-188 | ITEC_DENWA_APP-129 | Bug fix | [Android] 通話中のTransferボタン表示 | Android受電側の通話中画面にTransferボタンを表示する。 | VTI_SAM | 2026-05-28 |  | 2026-05-29 | Completed | High | ボタンからattended transferを開始できる。 |  | お客様Backlog VOIP_APL-188と同一内容。 |
| DENWA-WBS-013 | VOIP_APL-188 | ITEC_DENWA_APP-129 | Bug fix | [iOS] 通話中のTransferボタン表示 | iOS受電側の通話中画面にTransferボタンを表示する。 | VTI_SAM | 2026-05-28 |  | 2026-05-29 | Completed | High | ボタンからattended transferを開始できる。 |  | お客様Backlog VOIP_APL-188と同一内容。 |
| DENWA-WBS-014 | VOIP_APL-186 | ITEC_DENWA_APP-144 | Scope item | UAT資料共有と最終確認依頼 | UAT資料とエビデンスを共有し、顧客確認を依頼する。 | VTI_SAM | 2026-05-28 | 2026-05-28 | 2026-05-29 | Completed | High | VOIP_APL-186に資料リンクと確認依頼を登録している。 |  | 片山様、鈴木様へ通知済み。資料: https://drive.google.com/drive/folders/1DDMjBlvUwvbfGZ4snB_KBa7Dcqhf8zEi |
| DENWA-WBS-015 | VOIP_APL-169 | ITEC_DENWA_APP-145 | Scope item | Web/Mobileマニュアルの完成 | Web管理システムとMobileアプリの提出用マニュアルを完成させる。 | VTI_SAM | 2026-05-28 | 2026-05-29 | 2026-05-29 | Completed | High | Web/Mobileマニュアルを提出可能にし、Mobile版へTransferフローを反映する。 |  | Web/Mobile資料を確認・作成済み。 |
| DENWA-WBS-016 |  | ITEC_DENWA_APP-131 | Task | VPN/GitLabアカウント発行対応 | ソースレビューに必要なVPN/GitLabアクセスを準備する。 | VTI_SAM | 2026-05-29 |  | 2026-05-29 | Completed | Medium | 対象者が接続・閲覧できる。 |  | PM Trangと手続きを進める。 |
| DENWA-WBS-017 | VOIP_APL-155 | ITEC_DENWA_APP-146 | Task | STG環境の固定OTP付きテストアカウント作成 | STGのTenant ID 111にTransfer確認用アカウントを3件作成する。 | VTI_SAM | 2026-05-29 | 2026-05-29 | 2026-06-02 | Completed | Medium | 3アカウントで固定OTP「123456」によるログインを確認する。 |  | お客様ドメインと既存IP Groupを使用する。 |
| DENWA-WBS-018 | VOIP_APL-135 | ITEC_DENWA_APP-147 | Bug fix | [Android/iOS] アプリ強制終了時におけるVoIPシステムの制限分析 | アプリ強制終了時に通話が継続する事象を分析する。 | VTI_SAM | 2026-06-03 | 2026-06-03 | 2026-06-03 | Completed | Medium | OS/SIP制約と対応可能範囲を整理し、顧客へ回答する。 | R-001 | システム制約として回答準備済み。 |
| DENWA-WBS-019 | VOIP_APL-189 | ITEC_DENWA_APP-148 | Bug fix | [iOS] 通話中のホームボタン押下に伴うプラットフォーム制限の分析 (VOIP_APL-189) | iOS古端末のホームボタン操作時の挙動を確認する。 | VTI_SAM | 2026-06-04 | 2026-06-05 | 2026-06-05 | Awaiting Customer | High | 一時ペンディング方針について顧客合意を得る。 |  | 片山様の回答待ち。 |
| DENWA-WBS-020 |  | ITEC_DENWA_APP-149 | Task | 鈴木様要求に基づくセキュリティチェックポイントの調査 | セキュリティチェックポイントを調査し、レポートと関連修正をまとめる。 | VTI_SAM | 2026-06-01 | 2026-06-05 | 2026-06-08 | Awaiting Customer Review | High | レポートと関連修正について鈴木様のレビュー・承認を得る。 |  | 鈴木様レビュー待ち。 |
| DENWA-WBS-021 |  | ITEC_DENWA_APP-150 | Verification | 岡田電機様の提案に基づくMVEおよびAPIの仕様変更の確認 | MVE提案の仕様変更内容を関係者と確認する。 | VTI_SAM | 2026-06-08 |  | 2026-06-12 | Awaiting Customer | High | 対応方針と修正範囲を合意する。 |  | 岡田電機様の説明待ち。 |
| DENWA-WBS-022 |  | ITEC_DENWA_APP-151 | Scope item | リリース計画策定、WBS構築およびリリースガイド準備（App Store, Google Play, API & インフラ） | リリース計画とWBSを作成し、App Store、Google Play、API、インフラの役割分担を整理する。 | VTI_SAM | 2026-06-08 |  | 2026-06-10 | Completed | High | 計画、WBS、役割分担を確認できる。 |  | 成果物: WBS |
| DENWA-WBS-024 |  | ITEC_DENWA_APP-152 | Scope item | Web管理マニュアルの標準化または分離 | Web管理マニュアルをロール別に整理し、Tenant Admin向けにSIP Phoneの登録・設定手順を追加する。 | VTI_SAM | 2026-06-08 |  | 2026-06-15 | Completed | High | ロール別の内容を確認できる。 |  | 成果物: Manual |
| DENWA-WBS-025 |  | ITEC_DENWA_APP-137 | Task | WEB側のセキュリティ指摘事項の検証 | StagingのAdmin Portalについて、ブルートフォース/lockout、SQL Injection（login/dynamic schema）、HTTP headers（CSP, X-Frame-Options, HSTS）、XSS、CSRF、JWT/Cookie（HttpOnly, Secure, SameSite）、IP whitelist/X-Forwarded-For、API authorization/IDORを検証し、PoC request/response evidenceを整理する。 | VTI_SAM | 2026-06-08 |  | 2026-06-19 | Completed | High | 10項目の検証、エビデンス整理、レポート更新を完了する。 |  | 成果物: Security |
| DENWA-WBS-026 |  | ITEC_DENWA_APP-163 | Scope item | WebアプリUAT項目書作成（システム管理者・テナント管理者） | Web管理画面のUAT項目書をシステム管理者・テナント管理者のロール別に作成する。 | VTI_SAM | 2026-06-08 |  | 2026-06-12 | Completed | High | ロール別のUAT項目書を確認できる。 |  | 成果物: Testcase |
| DENWA-WBS-028 |  |  | Task | 6月30日のリリース範囲とリリース可否条件を確定する | 6月30日のリリース範囲とリリース可否条件を確定する。 | 片山 剛 | 2026-06-10 |  | 2026-06-12 | Completed | High | リリース範囲と可否条件を確認できる。 |  | 成果物: WBS |
| DENWA-WBS-029 |  |  | Task | APIの本番環境を準備する | APIの本番環境を利用可能にする。 | VTI_SAM | 2026-06-10 |  | 2026-06-12 | Completed | High | 本番APIの準備を完了する。 |  | API PRD pipeline 707796、Front PRD pipeline 707795、Front dev CI 707804の成功を確認済み。 |
| DENWA-WBS-030 |  |  | Task | 本番APIの簡易確認を実施する | 本番APIの主要エンドポイントを簡易確認する。 | VTI_SAM | 2026-06-11 |  | 2026-06-12 | Completed | High | PRD Front smokeと認証応答を確認する。 |  | API認証系endpointの401応答を確認し、5xx/CORSではないことを確認済み。 |
| DENWA-WBS-031 |  |  | Task | MVE本番環境の設定を確認する | MVE本番環境のendpoint、credential、callback、allowlistを確認する。 | 野崎 祐也 | 2026-06-12 |  | 2026-06-15 | Completed | High | MVE本番がAPI/appと連携可能な状態である。 |  | endpoint/credential/callback/allowlistを確認済み。 |
| DENWA-WBS-032 |  |  | Task | 本番環境向けSIP Phone設定を準備する | 本番用SIP account、電話番号、tenant、IP Groupを準備する。 | 野崎 祐也 | 2026-07-06 |  | 2026-07-10 | In Progress | High | SIP account、電話番号、tenant、IP Groupが本番利用可能である。 |  | 実機確認は岡田/ITEC側。 |
| DENWA-WBS-033 |  |  | Task | Web ManualにSIP Phone設定手順を追加する | Web ManualにTenant Admin向けSIP Phone登録・設定手順を追加する。 | VTI_SAM | 2026-07-06 |  | 2026-07-10 | In Progress | High | Tenant Admin向け登録・設定手順を確認できる。 |  | 既存Manualを更新する。 |
| DENWA-WBS-034 |  |  | Task | mobile app/API/MVEの結合確認を実施する | mobile app、API、MVEの主要フローを結合確認する。 | VTI_SAM | 2026-07-06 |  | 2026-07-10 | In Progress | High | 発信・着信・push・call・transfer・終話を確認する。 |  | VTIはapp/API範囲を担当する。 |
| DENWA-WBS-035 |  |  | Task | 本番環境でSIP Phoneの動作確認を実施する | 本番環境でSIP Phoneとmobileの発着信・終話を確認する。 | 野崎 祐也 | 2026-07-06 |  | 2026-07-10 | In Progress | High | SIPとmobileの主要通話フローを確認する。 |  | VTIはlog/API/app調査を支援する。 |
| DENWA-WBS-036 |  | ITEC_DENWA_APP-165 | Bug fix | UATで発生した不具合を修正し再確認する | UATで発生した不具合を修正し、再確認する。 | VTI_SAM | 2026-06-15 |  | 2026-06-18 | Completed | High | 重大不具合を解消し、残課題についてITEC了承を得る。 |  | UAT_VoIP電話アプリテストケース.xlsx。UAT関連のAPI/Front修正をPRDへ反映済み。CI/CD成功とPRD簡易確認済み。 |
| DENWA-WBS-037 |  |  | Scope item | App Store／Google Play提出情報を準備する | ストア提出用のmetadata、screenshot、privacy、review note、テストアカウントを準備する。 | VTI_SAM | 2026-06-16 |  | 2026-06-18 | Completed | High | 提出情報と3アカウントを準備する。 |  | reviewerログイン情報を明記する。 |
| DENWA-WBS-038 |  |  | Scope item | production接続用release noteを作成する | production接続用release noteを作成し、build、version、signing、production接続を確認する。 | VTI_SAM | 2026-06-18 |  | 2026-06-19 | Completed | High | iOS/Android buildを導入可能な状態にする。 |  | iOS TestFlight確認済み。API/FrontのPRD deploy成功を確認済み。 |
| DENWA-WBS-039 |  |  | Task | App Store／Google Playへ審査提出する | アプリをApp StoreとGoogle Playへ審査提出する。 | VTI_SAM | 2026-06-19 |  | 2026-06-19 | Completed | High | 両ストアへの提出を確認する。 |  | 予備日6/22(月)。 |
| DENWA-WBS-040 |  |  | Task | 審査通過後、ユーザー向けにはまだ公開しない | 審査通過後は公開操作を保留し、公開可能な状態を維持する。 | VTI_SAM | 2026-06-22 |  | 2026-06-26 | Completed | High | 審査通過後にユーザー公開を保留できる。 |  | 再審査不要の状態を維持する。 |
| DENWA-WBS-041 |  |  | Task | 6月30日に公開するか延期するか最終判断する | 6月30日の公開可否を最終判断する。 | 片山 剛 | 2026-06-29 |  | 2026-06-29 | Completed | High | 公開実施または延期の判断を明確にする。 |  | 重大未解決の場合は公開しない。 |
| DENWA-WBS-042 |  |  | Task | ユーザー向けにアプリを正式公開する | ユーザー向けにアプリを正式公開する。 | 片山 剛 | 2026-06-30 |  | 2026-06-30 | Completed | High | ユーザーがStoreから取得・更新できる。 |  | 公開後にproductionを簡易確認する。 |
| DENWA-WBS-043 |  |  | Task | リリース後監視 | 公開後の不具合とログを監視する。 | VTI_SAM | 2026-06-30 |  | 2026-07-03 | In Progress | High | 連絡、調査、hotfix方針を整理する。 |  | MVE/SIPは岡田側と連携する。 |
