# TC-IT-API-03 VoIPWebAPI自動化判定

- Source: `UAT_VoIP電話ウェブ側テストケース.xlsx`
- Total testcase: 104
- api: 37
- api_with_stub: 67
- ui_smoke_only: 0
- review: 0

| Role | Group | TC ID | Priority | Testcase | Automation | Stub/Control | API/Service Focus | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| システム管理者 | ログイン・セキュリティ | AUTH-01 | H | システム管理者が正常にログインする（IPホワイトリスト） | api_with_stub | mail capture, DB OTP/mail capture, IP property override | /auth/admin/* | seeded in initial IT |
| システム管理者 | ログイン・セキュリティ | AUTH-02 | H | ログイン失敗 — パスワード誤り | api_with_stub | mail capture | /auth/admin/* | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-03 | M | ログイン失敗 — IPがホワイトリスト外（システム/岡田電機管理者） | api_with_stub | IP property override | /auth/admin/* | seeded in initial IT |
| システム管理者 | ログイン・セキュリティ | AUTH-04 | H | パスワード変更成功 | api | - | /auth/admin/login-with-role | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-05 | M | パスワード変更失敗 — 新しいパスワードが条件を満たさない | api | - | /auth/admin/* | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-06 | H | メールOTPによるパスワード復旧 | api_with_stub | mail capture, DB OTP/mail capture | /auth/admin/* | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-07 | M | パスワード再設定時にOTPを5回連続で誤入力する | api_with_stub | mail capture, DB OTP/mail capture, DB timestamp | /auth/admin/* | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-08 | M | OTPを5回誤入力した後、ロック時間内に再度パスワード再設定を試行する | api_with_stub | mail capture, DB OTP/mail capture | /auth/admin/* | planned |
| システム管理者 | ログイン・セキュリティ | AUTH-09 | M | 5回連続ログイン失敗 | api_with_stub | mail capture | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T01 | H | 新規テナント作成 — 固定電話を利用するテナント | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T02 | H | 新規テナント作成 — 固定電話を利用しない | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T03 | H | テナント作成失敗 — テナント番号が範囲外（固定電話） | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T04 | M | テナント作成失敗 — テナント管理者不足 | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T05 | M | テナント名でテナントを検索 | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T06 | M | 「登録待ち」状態でテナントを絞り込む | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T07 | M | テナント情報詳細を確認 | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T08 | M | 一覧表示 ユーザー 内 テナント (ポップアップ ビュー) | api_with_stub | mail capture | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T09 | M | 当月ユーザー数履歴を確認 | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T10 | M | テナント契約情報を編集 | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T11 | M | テナント編集履歴を確認（テナント編集履歴） | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T12 | H | 「利用中」テナントを停止 | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T13 | H | テナントが「停止」状態の場合に「停止する」ボタンが非表示であることを確認 | api | - | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T14 | H | 「停止」状態のテナントを再有効化 | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T15 | H | テナント削除 | api | - | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T16 | H | テナント管理者へログイン情報を送信 | api_with_stub | mail capture | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T17 | M | すでにメール受信済みのテナント管理者には再送信しない | api_with_stub | mail capture | /auth/admin/* | planned |
| システム管理者 | テナント管理 | SA-T18 | M | テナント一覧をCSV出力 | api_with_stub | file response assert | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T19 | H | ユーザー状態同期の手動バッチを起動 | api_with_stub | MVE fake server, mail capture | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T20 | M | 「削除済み」ユーザーを自動バッチで確認 | api_with_stub | MVE fake server, batch trigger/DB timestamp | /tenant/* | planned |
| システム管理者 | テナント管理 | SA-T21 | M | ユーザーインポートCSVテンプレートをダウンロード | api_with_stub | file response assert | /auth/admin/* | planned |
| システム管理者 | ユーザーインポート | SA-I01 | H | システム管理者ロールでインポートユーザー画面への遷移を確認 | api | - | /auth/admin/login-with-role | planned |
| システム管理者 | ユーザーインポート | SA-I02 | H | システム管理者ロールでインポートユーザー画面への遷移を確認 | api | - | /auth/admin/login-with-role | planned |
| システム管理者 | ユーザーインポート | SA-I03 | H | 有効なCSVアップロード — すべてのユーザー作成成功 | api_with_stub | MVE fake server | /auth/admin/* | planned |
| システム管理者 | ユーザーインポート | SA-I04 | H | アップロード失敗 — ファイルがCSVではない | api | - | /auth/admin/* | planned |
| システム管理者 | ユーザーインポート | SA-I05 | H | アップロード失敗 — CSVヘッダーがテンプレートと異なる | api_with_stub | MVE fake server | /tenant/insert-user-csv or /users/insert-user-csv | planned |
| システム管理者 | ユーザーインポート | SA-I06 | H | アップロード失敗 — CSVファイルが空 | api | - | /tenant/insert-user-csv or /users/insert-user-csv | planned |
| システム管理者 | ユーザーインポート | SA-I07 | H | アップロード失敗 — エラーデータあり（メールアドレス重複） | api_with_stub | mail capture, file response assert | /tenant/insert-user-csv or /users/insert-user-csv | planned |
| システム管理者 | ユーザーインポート | SA-I08 | H | アップロード失敗 — 同一テナント内でSIP番号が重複 | api_with_stub | file response assert | /tenant/* | planned |
| システム管理者 | ユーザーインポート | SA-I09 | H | エラーファイル修正後に再アップロード | api | - | /tenant/insert-user-csv or /users/insert-user-csv | planned |
| システム管理者 | ユーザーインポート | SA-I10 | M | アップロード失敗 — ファイルが50MB超 | api_with_stub | generated large CSV fixture | /tenant/insert-user-csv or /users/insert-user-csv | planned |
| システム管理者 | ユーザーインポート | SA-I11 | H | アップロード失敗 — SIP番号が無効 | api_with_stub | file response assert | /tenant/* | planned |
| システム管理者 | ユーザーインポート | SA-I12 | H | アップロード失敗 — SIP番号が無効 | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ログイン・セキュリティ | AUTH-01 | H | テナント管理者ログイン — OTP受信・入力成功 | api_with_stub | mail capture, DB OTP/mail capture, DB timestamp | /auth/admin/* | seeded in initial IT |
| テナント管理者 | ログイン・セキュリティ | AUTH-02 | M | OTP期限切れ — OTP再送信成功 | api_with_stub | DB OTP/mail capture, DB timestamp | /auth/admin/* | planned |
| テナント管理者 | ログイン・セキュリティ | AUTH-03 | H | パスワード変更成功 | api | - | /auth/admin/login-with-role | seeded in initial IT |
| テナント管理者 | ログイン・セキュリティ | AUTH-04 | M | パスワード変更失敗 — 新しいパスワードが条件を満たさない | api | - | /auth/admin/* | planned |
| テナント管理者 | ログイン・セキュリティ | AUTH-05 | H | メールOTPによるパスワード復旧 | api_with_stub | mail capture, DB OTP/mail capture | /auth/admin/* | planned |
| テナント管理者 | ログイン・セキュリティ | AUTH-06 | M | 5回連続ログイン失敗 | api_with_stub | mail capture | /auth/admin/* | planned |
| テナント管理者 | ログイン・セキュリティ | AUTH-10 | M | OTPを5回連続で誤入力する | api_with_stub | DB OTP/mail capture | /auth/admin/* | planned |
| テナント管理者 | ユーザー管理 | TA-U01 | M | 一覧表示 ユーザー 後 ログイン | api | - | /auth/admin/* | planned |
| テナント管理者 | ユーザー管理 | TA-U02 | M | メールアドレスでユーザーを検索 | api_with_stub | mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U03 | M | 氏名でユーザーを検索 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U04 | M | 「利用中」状態でユーザーを絞り込む | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U05 | H | 新規ユーザー追加成功（MVE API成功） | api_with_stub | MVE fake server, mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U06 | H | ユーザー追加失敗 — メールアドレスがシステム内に既に存在 | api_with_stub | mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U07 | H | ユーザー追加失敗 — SIP番号がテナント内で使用済み | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U08 | H | ユーザー追加失敗 — 必須項目不足 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U09 | H | テナント種別ごとのSIP範囲を確認 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U10 | M | ユーザー情報詳細を確認 | api_with_stub | mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U11 | M | 「削除済み」状態のユーザーで「編集」「削除」ボタンを確認 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U12 | M | ユーザー情報編集 — 氏名を更新 | api_with_stub | mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U13 | H | 「登録済み」ユーザーへ有効化メールを送信 | api_with_stub | mail capture | /auth/admin/* | planned |
| テナント管理者 | ユーザー管理 | TA-U14 | H | 「アクティブ待ち」ユーザーへ有効化メールを再送信 | api_with_stub | mail capture | /auth/admin/* | planned |
| テナント管理者 | ユーザー管理 | TA-U15 | H | 「登録済み」「アクティブ待ち」以外の状態のユーザーには有効化メールを送信できない | api_with_stub | mail capture | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U16 | M | 「戻る」ボタンでユーザー一覧へ戻る | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー管理 | TA-U17 | M | ダウンロード テンプレート CSV から 画面 ユーザー一覧 | api_with_stub | file response assert | /auth/admin/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I01 | H | 有効なCSVアップロード — すべてのユーザーが作成される | api_with_stub | MVE fake server | /auth/admin/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I02 | H | アップロード失敗 — ファイル未選択 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I03 | H | アップロード失敗 — ヘッダーのみでデータなし | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I04 | H | アップロード失敗 — データのみでヘッダーなし | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I05 | H | アップロード 失敗 —姓 含む 特殊文字 ない 有効 | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I06 | H | アップロード失敗 — 姓カナにカタカナ以外を含む | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I07 | H | アップロード失敗 — SIP番号が4桁ではない（固定電話テナント） | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I08 | H | アップロード失敗 — SIP番号が無効 | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I09 | H | アップロード失敗 — SIP番号が無効 | api_with_stub | file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I10 | H | アップロード失敗 — 同一CSVファイル内でメールアドレスが重複 | api_with_stub | mail capture, file response assert | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I11 | H | メンテナンス中にインポートが無効化されることを確認 | api_with_stub | maintenance fixture | /tenant/* | planned |
| テナント管理者 | ユーザー一括インポート | TA-I12 | H | メンテナンス終了後にインポートが正常復旧する | api_with_stub | maintenance fixture | /tenant/* | planned |
| テナント管理者 | ユーザー削除 | TA-D01 | H | ユーザー削除成功 | api | - | /auth/admin/* | planned |
| テナント管理者 | ユーザー削除 | TA-D02 | H | 「削除済み」ユーザーが一覧に表示され続けることを確認 | api | - | /tenant/* | planned |
| テナント管理者 | ユーザー削除 | TA-D03 | H | 岡田電機がメンテナンス実施後、SIPアカウントがMVEから削除される | api_with_stub | MVE fake server, maintenance fixture, file response assert | /tenant/* | planned |
| 岡田電機管理者 | ログイン・セキュリティ | AUTH-02 | H | 岡田電機管理者が正常にログインする（IPホワイトリスト） | api_with_stub | mail capture, DB OTP/mail capture, IP property override | /auth/admin/* | planned |
| 岡田電機管理者 | ログイン・セキュリティ | AUTH-05 | H | ログイン失敗 — IPがホワイトリスト外（システム/岡田電機管理者） | api_with_stub | IP property override | /auth/admin/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T01 | M | テナントIDでテナントを検索 | api_with_stub | MVE fake server | /tenant/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T02 | M | IPGroup Nameでテナントを検索 | api_with_stub | MVE fake server | /tenant/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T03 | M | 「登録待ち」テナントが一覧の先頭に優先表示されることを確認 | api_with_stub | MVE fake server | /tenant/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T04 | H | 「登録待ち」テナントのIPGroup Name作成完了を確認 | api_with_stub | MVE fake server, mail capture | /tenant/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T05 | H | IPGroup確認 — 「利用中」テナントではボタンが使用不可 | api_with_stub | MVE fake server | /tenant/* | planned |
| 岡田電機管理者 | テナント_IPGroupName管理 | OD-T06 | M | 複数テナントのIPGroupを一括確認 | api_with_stub | MVE fake server, mail capture | /tenant/* | planned |
| 岡田電機管理者 | メンテナンス | OD-M01 | M | ポップアップで「キャンセル」をクリックした場合にメンテナンスをキャンセル | api_with_stub | maintenance fixture | /mve-admin/* | planned |
| 岡田電機管理者 | メンテナンス | OD-M02 | H | メンテナンス開始 成功 | api_with_stub | maintenance fixture | /auth/admin/* | planned |
| 岡田電機管理者 | メンテナンス | OD-M03 | H | メンテナンス中にアプリの通話/メッセージが無効化される | api_with_stub | maintenance fixture | /mve-admin/* | planned |
| 岡田電機管理者 | メンテナンス | OD-M04 | H | メンテナンス終了 成功 | api_with_stub | MVE fake server, maintenance fixture | /mve-admin/* | planned |
| 岡田電機管理者 | メンテナンス | OD-M06 | H | メンテナンス中にログアウト・再ログインしても状態は解除されない | api_with_stub | maintenance fixture | /auth/admin/* | planned |
| 岡田電機管理者 | アカウント出力・MVE同期 | OD-E01 | H | SIPアカウント一覧CSVを出力 | api_with_stub | MVE fake server, file response assert | /auth/admin/* | planned |
| 岡田電機管理者 | アカウント出力・MVE同期 | OD-E02 | H | CSVファイルに有効状態のユーザーのみ含まれることを確認 | api_with_stub | MVE fake server, file response assert | /tenant/* | planned |
| 岡田電機管理者 | アカウント出力・MVE同期 | OD-E03 | H | CSVファイル内のデータ形式を確認 | api_with_stub | MVE fake server, file response assert | /tenant/* | planned |
| 岡田電機管理者 | アカウント出力・MVE同期 | OD-E05 | H | CSVファイルをMVEへインポート — 「削除済み」ユーザーがMVEから削除される | api_with_stub | MVE fake server, maintenance fixture, file response assert | /auth/admin/* | planned |
| 岡田電機管理者 | アカウント出力・MVE同期 | OD-E06 | H | ユーザー削除時のE2Eメンテナンス: 出力 → メンテナンス → MVEインポート → 終了 | api_with_stub | MVE fake server, maintenance fixture, file response assert | /auth/admin/* | planned |
| オンボーディングフロー |  | SA-OB01 | H | End-to-end: テナント作成 → アップロード ユーザー → 送信 メール テナント管理者 | api_with_stub | mail capture | /auth/admin/login-with-role | planned |
| オンボーディングフロー |  | SA-OB02 | H | テナント作成直後のユーザーアップロード手順をスキップ | api | - | /tenant/* | planned |
| オンボーディングフロー |  | SA-OB03 | H | 岡田電機がIPGroup確認後、ユーザー状態が「登録済み」になることを確認 | api_with_stub | MVE fake server | /auth/admin/login-with-role | planned |
| オンボーディングフロー |  | SA-OB04 | H | ユーザーのアカウント有効化確認 — 状態「利用中」 | api_with_stub | mail capture | /auth/admin/login-with-role | planned |
| オンボーディングフロー |  | SA-OB05 | H | メール受信後にテナント管理者がログインできることを確認 | api_with_stub | mail capture | /auth/admin/* | planned |
