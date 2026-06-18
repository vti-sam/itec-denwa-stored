# 2026年6月30日リリース向けWBS案

## 目的
2026年6月30日の正式リリースに向けて、アプリ、API/インフラ、MVE、SIP Phone、ストア公開準備の作業範囲と担当を整理する。

本WBSでは、6月30日を「ストア審査開始日」ではなく、「審査通過済みアプリを正式公開する日」として扱う。事前にApp Store / Google Playへ審査提出し、審査通過後はユーザー向けには公開せず、6月30日の最終確認後に公開操作を行う。審査通過後に新しいビルドをアップロードしない限り、公開操作時の再審査は不要とする。

## WBS案

| No | 分類 | 作業項目 | 主担当 | 関係者 | 期限 | 完了条件 | 備考 |
|---|---|---|---|---|---:|---|---|
| REL-01 | リリース計画 | 6月30日のリリース範囲とリリース可否条件を確定する | ITEC | VTI, 岡田電機 | 6/12(金) | リリース前に必須で完了すべき項目と、リリース後対応可能な項目が整理されている | 最終判断はITECにて実施 |
| REL-02 | API/インフラ | APIの本番環境を準備する | VTI | ITEC | 6/12(金) | `stg` から `prd` への名称・設定変更、環境変数、secret、domain等の確認が完了している | 環境名称変更が中心であれば、先行して実施可能 |
| REL-03 | API/インフラ | 本番APIの簡易確認を実施する | VTI | ITEC | 6/12(金) | 事前準備済みの3つのテストアカウントで、login、tenant、user、push/call関連の主要APIが確認できている | Store review noteにもテストアカウント情報を記載 |
| REL-04 | MVE | MVE本番環境の設定を確認する | 岡田電機 | ITEC, VTI | 6/15(月) | MVE本番環境がAPI/appと連携可能な状態になっている | endpoint、credential、callback、allowlist等を確認 |
| REL-05 | SIP Phone | 本番環境向けSIP Phone設定を準備する | 岡田電機 | ITEC | 6/17(水) | SIP account、電話番号、tenant/SIPP tenant、IP Group等が本番利用可能な状態になっている | SIP Phone実機・環境確認は岡田電機またはITEC側で実施 |
| REL-06 | ドキュメント | Web ManualにSIP Phone設定手順を追加する | VTI | ITEC, 岡田電機/Nozaki様 | 6/17(水) | Tenant Admin向けにSIP Phoneの登録・設定手順が確認できる状態になっている | 既存のWeb Manual更新タスクに関連 |
| REL-07 | 結合確認 | mobile app、API、MVEの結合確認を実施する | VTI | ITEC, 岡田電機 | 6/18(木) | 発信、着信、push/call、transfer、終話など主要フローが確認できている | VTIはapp/API側で確認可能な範囲を担当 |
| REL-08 | SIP Phone確認 | 本番環境でSIP Phoneの動作確認を実施する | 岡田電機またはITEC | VTI | 6/18(木) | SIP Phoneからmobile appへの発信、mobile appからSIP Phoneへの発信、SIP Phone側での終話等が確認できている | VTIは必要に応じてlog/API/app側の調査を支援 |
| REL-09 | UAT/不具合対応 | UATで発生した不具合を修正し、再確認する | VTI | ITEC | 6/18(木) | 重大な不具合が解消されている。残課題がある場合は、リリース後対応可否についてITECの了承を得ている | DENWA-WBS-027に関連 |
| REL-10 | ストア準備 | App Store / Google Play提出情報を準備する | ITEC | VTI | 6/18(木) | metadata、screenshot、privacy情報、review note、3つのテストアカウント情報が準備されている | reviewerがログイン・確認できる情報を明記 |
| REL-11 | mobile app | production接続用のrelease candidateを作成する | VTI | ITEC | 6/19(金) | iOS/Android buildがインストール可能で、version/build number、signing、production接続が確認できている | iOSはTestFlightで確認済みのため、差分を最小化する |
| REL-12 | ストア審査 | App Store / Google Playへ審査提出する | VTI（権限がある場合） | ITEC | 6/19(金) | アプリがストア審査に提出されている | 6/19に間に合わない場合の予備日は6/22(月) |
| REL-13 | ストア審査 | ストア審査通過後、ユーザー向けにはまだ公開しない | VTI/ITEC | - | 6/26(金) | App Store / Google Playの審査に通過し、公開可能な状態になっている | 6/30は審査開始日ではなく公開操作日。新しいbuildをuploadしない限り、公開時の再審査は不要 |
| REL-14 | 最終判断 | 6月30日に公開するか延期するかを最終判断する | ITEC | VTI, 岡田電機 | 6/29(月) | 公開実施または延期の判断が明確になっている | 重大な未解決不具合がある場合は公開しない |
| REL-15 | 正式公開 | ユーザー向けにアプリを正式公開する | ITEC（判断）、VTI（権限がある場合は操作） | 岡田電機 | 6/30(火) | ユーザーがApp Store / Google Playからアプリを取得・更新できる状態になっている | 公開後、production環境で簡易確認を実施 |
| REL-16 | リリース後監視 | 公開後の不具合・ログを監視する | VTI | ITEC, 岡田電機 | 7/3(金) | 不具合発生時の連絡・調査・hotfix方針が整理されている | MVE/SIP Phone関連は岡田電機のstandbyが必要 |

## リリース当日の想定

| 日付 | 内容 |
|---:|---|
| 6/30(火) 午前 | ITECにて最終公開可否を確認する |
| 6/30(火) 公開操作 | 審査通過済みアプリをApp Store / Google Playで正式公開する |
| 6/30(火) 公開後 | VTIがproduction環境でapp/APIの簡易確認を実施する |
| 6/30(火) 公開後 | 岡田電機またはITECがMVE/SIP Phone側の確認を実施する |

## 補足

- 6月30日はストア審査を開始する日ではなく、審査通過済みアプリを公開する日とする。
- ストア審査通過後に新しいbuildをアップロードしない限り、公開操作時に再審査は不要。
- SIP Phoneの実機確認は岡田電機またはITECが担当し、VTIは必要に応じてapp/API/logの確認を支援する。
- 3つのテストアカウントは、ストア審査およびproduction確認で利用できるようreview noteに明記する。
