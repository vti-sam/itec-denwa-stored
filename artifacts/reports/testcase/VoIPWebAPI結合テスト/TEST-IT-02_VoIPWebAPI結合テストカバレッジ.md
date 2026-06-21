# UAT VoIP API IT Test Cases

- Source testcase gốc: `UAT_VoIP電話ウェブ側テストケース.xlsx`
- Bản render testcase gốc: `project-store/artifacts/reports/testcase/VoIPWebテストケース/TEST-UAT-01_VoIPWebテストケース.md`
- Bản phân loại automation ban đầu: `project-store/artifacts/reports/testcase/VoIPWebAPI自動化判定/TEST-AUTO-01_VoIPWebAPI自動化判定.md`
- Code test đã chạy:
  - `sources/denwa-api/src/test/java/jp/co/itec/denwa/it/VoipWebApiRegressionIT.java`
  - `sources/denwa-api/src/test/java/jp/co/itec/denwa/it/AuthApiIT.java`
  - `sources/denwa-api/src/test/java/jp/co/itec/denwa/it/AuthIpWhitelistDeniedIT.java`
- Local verification gần nhất: full API IT suite `110 tests`, `0 failures`, `0 errors`, `0 skipped`

## Mục đích

Tài liệu này là bản testcase đã chỉnh sang **API integration test** để phản ánh đúng nội dung đang được automate trong local API IT suite.

Tài liệu này không thay thế testcase UI gốc. Nhóm 104 case đầu giữ trace về `Role + TC ID` của testcase gốc, nhưng mô tả lại phần đã được kiểm thử bằng API, DB seed và stub trong local integration harness. Nhóm 6 case cuối là API guard case bổ sung để bảo vệ auth/IP whitelist behavior.

## Quy tắc chuyển đổi

| Nội dung testcase UI gốc | Cách kiểm thử trong API IT |
| --- | --- |
| Truy cập màn hình, click button, nhập form | Gọi trực tiếp API backend tương ứng bằng `TestRestTemplate` |
| Màn hình/list/detail hiển thị dữ liệu | Assert HTTP `200` và payload JSON/byte response có dữ liệu mong đợi |
| Validation lỗi trên UI | Assert HTTP `4xx` từ API |
| Không lỗi server | Assert response không phải `5xx` |
| Gửi mail/OTP | Dùng test mail/DB OTP capture trong local harness |
| MVE API | Dùng fake/stub MVE server trong test context |
| S3/file download | Dùng test stub và assert byte response |
| Data trước mỗi case | `resetDatabase()` rồi seed fixture lại từ đầu |

## Mức coverage

| Level | Ý nghĩa |
| --- | --- |
| `equivalent` | API IT kiểm tra gần tương đương business result của testcase gốc. |
| `api-equivalent` | UI thao tác được thay bằng API call, business/API result tương đương nhưng không assert DOM. |
| `negative-equivalent` | Testcase lỗi được cover bằng API lỗi tương ứng. |
| `smoke` | Chỉ kiểm tra endpoint/flow chính không lỗi hoặc có response cơ bản. |
| `partial` | Chỉ cover một phần intent; còn thiếu UI, file detail, mail detail, MVE/mobile side effect hoặc trạng thái phụ. |

## Converted Web API Regression Cases

Nhóm này gồm 104 case chuyển đổi từ testcase web gốc và đang được chạy trong `VoipWebApiRegressionIT`.

| # | Role | TC ID | Testcase gốc | API IT method | Nội dung API IT đang kiểm thử | Coverage / gap |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | システム管理者 | AUTH-01 | システム管理者が正常にログインする（IPホワイトリスト） | `systemAdminLoginOk` | Login system admin và assert access token được phát hành. | `api-equivalent`; không assert điều hướng UI tới tenant list. |
| 2 | システム管理者 | AUTH-02 | ログイン失敗 — パスワード誤り | `adminWrongPasswordRejected` | Gọi `/auth/admin/login` bằng password sai và assert HTTP `4xx`. | `negative-equivalent`; không assert text lỗi trên UI. |
| 3 | システム管理者 | AUTH-03 | ログイン失敗 — IPがホワイトリスト外（システム/岡田電機管理者） | `systemAdminIpDenied` | Override whitelist system admin thành IP khác, login system admin và assert `401 Unauthorized`. | `equivalent`; cover đúng bug IP whitelist ở backend. |
| 4 | システム管理者 | AUTH-04 | パスワード変更成功 | `systemAdminChangePasswordOk` | Login system admin, gọi `/auth/admin/change-password`, sau đó re-login bằng password mới và assert access token. | `api-equivalent`; không assert màn hình đổi mật khẩu. |
| 5 | システム管理者 | AUTH-05 | パスワード変更失敗 — 新しいパスワードが条件を満たさない | `systemAdminWeakPasswordRejected` | Gọi `/auth/admin/change-password` với password yếu và assert HTTP `4xx`. | `negative-equivalent`; không assert message UI. |
| 6 | システム管理者 | AUTH-06 | メールOTPによるパスワード復旧 | `systemAdminResetPasswordOk` | Gọi forgot-password, send-otp, đọc OTP mới nhất trong DB rồi reset password và assert `200`. | `api-equivalent`; mail thật được thay bằng DB/mail capture. |
| 7 | システム管理者 | AUTH-07 | Nhập OTP sai 5 lần liên tiếp khi quên mật khẩu | `systemAdminWrongOtpRejected` | Gọi forgot-password rồi reset-password với OTP sai và assert HTTP `4xx`. | `negative-equivalent`; case lock sâu hơn được cover ở AUTH-08. |
| 8 | システム管理者 | AUTH-08 | Tiếp tục lấy lại mật khẩu sau khi đã nhập mã OTP sai 5 lần liên tiếp và chưa hết thời gian khóa | `systemAdminWrongOtpLockedRetryRejected` | Gọi reset-password OTP sai 5 lần, assert failure count và forgot-password tiếp tục bị reject. | `api-equivalent`; không assert text UI lock-window. |
| 9 | システム管理者 | AUTH-09 | 5回連続ログイン失敗 | `systemAdminWrongPasswordLockRejected` | Login password sai 5 lần, assert failure count/lock behavior và correct password vẫn bị reject. | `api-equivalent`; không assert text UI. |
| 10 | システム管理者 | SA-T01 | 新規テナント作成 — 固定電話を利用するテナント | `tenantCreateFixedPhoneOk` | Gọi `/tenant/add` multipart với tenant fixed-phone hợp lệ, assert tenant/admin mapping được tạo. | `api-equivalent`; không assert UI upload logo/transition. |
| 11 | システム管理者 | SA-T02 | 新規テナント作成 — 固定電話を利用しない | `tenantCreateMobileOnlyOk` | Gọi `/tenant/add` multipart với tenant mobile-only hợp lệ, assert tenant/admin mapping được tạo. | `api-equivalent`; không assert UI transition. |
| 12 | システム管理者 | SA-T03 | テナント作成失敗 — テナント番号が範囲外（固定電話） | `tenantCreateValidationWorks` | Gọi `/tenant/add` với dữ liệu invalid và assert HTTP `4xx`. | `negative-equivalent`; chưa assert đúng lỗi range tenant number. |
| 13 | システム管理者 | SA-T04 | テナント作成失敗 — テナント管理者不足 | `tenantCreateValidationWorks` | Gọi `/tenant/add` thiếu tenant admin list và assert HTTP `4xx`. | `negative-equivalent`; đúng hướng backend validation, không assert UI message. |
| 14 | システム管理者 | SA-T05 | テナント名でテナントを検索 | `tenantSearchByNameOk` | Gọi `/tenant/get` với `tenantName=Test` và assert `200`. | `api-equivalent`; chưa assert danh sách loại bỏ tenant không khớp. |
| 15 | システム管理者 | SA-T06 | 「登録待ち」状態でテナントを絞り込む | `tenantSearchWaitingOk` | Gọi `/tenant/get` với `tenantStatus=0`, assert `200` và payload chứa tenant `112`. | `api-equivalent`; không assert toàn bộ list chỉ gồm trạng thái đăng ký chờ. |
| 16 | システム管理者 | SA-T07 | テナント情報詳細を確認 | `tenantDetailsOk` | Gọi `/tenant/details?tenantId=111`, assert `200` và payload chứa tenant/admin fixture. | `api-equivalent`; không assert button UI. |
| 17 | システム管理者 | SA-T08 | 一覧表示 ユーザー 内 テナント (ポップアップ ビュー) | `tenantUserListOk` | Gọi `/tenant/get-user-list` với tenant `111`, assert payload chứa user fixture. | `api-equivalent`; không assert popup DOM. |
| 18 | システム管理者 | SA-T09 | 当月ユーザー数履歴を確認 | `tenantAccountHistoryOk` | Gọi `/tenant/account-history?tenantId=111`, assert `200` và `data` không rỗng. | `api-equivalent`; chưa assert rule count theo trạng thái user. |
| 19 | システム管理者 | SA-T10 | テナント契約情報を編集 | `tenantUpdateOk` | Gọi `/tenant/update` multipart với contract/billing/admin update hợp lệ, assert `200` và read-back DB field chính. | `api-equivalent`; chưa assert toàn bộ field UI. |
| 20 | システム管理者 | SA-T11 | テナント編集履歴を確認（テナント編集履歴） | `tenantEditHistoryOk` | Gọi `/tenant/edit-history` với tenant `111`, assert payload chứa old/new tenant name. | `api-equivalent`; không assert UI table. |
| 21 | システム管理者 | SA-T12 | 「利用中」テナントを停止 | `tenantSuspendOk` | Gọi `PUT /tenant/change-status` tenant `111` sang status `2` và assert `200`. | `api-equivalent`; chưa assert user app không login được. |
| 22 | システム管理者 | SA-T13 | テナントが「停止」状態の場合に「停止する」ボタンが非表示であることを確認 | `tenantSuspendedDetailsOk` | Gọi `/tenant/details?tenantId=113` cho tenant đang stop và assert `200`. | `partial`; backend detail only, chưa assert button visibility. |
| 23 | システム管理者 | SA-T14 | 「停止」状態のテナントを再有効化 | `tenantReactivateOk` | Gọi `PUT /tenant/change-status` tenant `113` sang status `1` và assert `200`. | `api-equivalent`; chưa assert user app login lại được. |
| 24 | システム管理者 | SA-T15 | テナント削除 | `tenantDeleteOk` | Gọi `DELETE /tenant/delete?tenantId=114`, assert row tenant bị xóa và login tenant admin bị reject. | `api-equivalent`; không assert UI confirm dialog. |
| 25 | システム管理者 | SA-T16 | テナント管理者へログイン情報を送信 | `tenantAdminMailOk` | Set `mail_sent=0`, gọi `/tenant/send-mail-tenant-admin`, assert mail capture có message và DB `mail_sent=1`. | `api-equivalent`; chưa assert HTML mail body chi tiết. |
| 26 | システム管理者 | SA-T17 | すでにメール受信済みのテナント管理者には再送信しない | `tenantAdminMailResendSkipped` | Gửi mail lần đầu, clear mail capture, gửi lại khi `mail_sent=1` và assert không tạo mail mới. | `api-equivalent`; không assert UI warning. |
| 27 | システム管理者 | SA-T18 | テナント一覧をCSV出力 | `tenantCsvDownloadOk` | Gọi `/tenant/download` và assert byte response `200`. | `api-equivalent`; chưa assert filename và toàn bộ cột CSV. |
| 28 | システム管理者 | SA-T19 | ユーザー状態同期の手動バッチを起動 | `syncUserStatusDoesNotCrash` | Gọi `/tenant/sync-user-status` và assert response không phải `5xx`. | `partial`; cover no-crash, chưa assert chuyển trạng thái và mail kết quả. |
| 29 | システム管理者 | SA-T20 | 「削除済み」ユーザーを自動バッチで確認 | `tenantUserDeletedVisibleOk` | Gọi `/tenant/get-user-list` với status `4`, assert payload chứa `deleted-user`. | `partial`; chưa chạy batch tự động/xóa SIP trong MVE. |
| 30 | システム管理者 | SA-T21 | ユーザーインポートCSVテンプレートをダウンロード | `tenantCsvTemplateOk` | Gọi `/tenant/insert-user-csv/template` và assert byte response `200`. | `api-equivalent`; chưa assert tên file/header đầy đủ. |
| 31 | システム管理者 | SA-I01 | システム管理者ロールでインポートユーザー画面への遷移を確認 | `systemAdminLoginWithRoleOk` | Gọi `/auth/admin/login-with-role` role `master_admin`, assert access token. | `partial`; chỉ cover role-token backend, chưa assert màn hình import. |
| 32 | システム管理者 | SA-I02 | システム管理者ロールでインポートユーザー画面への遷移を確認 | `systemAdminLoginWithRoleOk` | Gọi `/auth/admin/login-with-role` role `master_admin`, assert access token. | `partial`; duplicate UI navigation case được map chung backend role-token. |
| 33 | システム管理者 | SA-I03 | 有効なCSVアップロード — すべてのユーザー作成成功 | `tenantCsvValidUploadOk` | Upload CSV hợp lệ MS932/CRLF vào `/tenant/insert-user-csv`, assert user và account mapping được tạo. | `api-equivalent`; không assert browser file picker/progress UI. |
| 34 | システム管理者 | SA-I04 | アップロード失敗 — ファイルがCSVではない | `tenantCsvNonCsvRejected` | Upload `not-csv.txt` vào `/tenant/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`; không assert UI text. |
| 35 | システム管理者 | SA-I05 | アップロード失敗 — CSVヘッダーがテンプレートと異なる | `tenantCsvBadHeaderRejected` | Upload CSV header sai vào `/tenant/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`; chưa assert không gọi MVE. |
| 36 | システム管理者 | SA-I06 | アップロード失敗 — CSVファイルが空 | `tenantCsvEmptyRejected` | Upload empty CSV vào `/tenant/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`. |
| 37 | システム管理者 | SA-I07 | アップロード失敗 — エラーデータあり（メールアドレス重複） | `tenantCsvInvalidDataRejectedWithErrorFile` | Upload invalid CSV và assert HTTP `4xx` trả tên error file `.csv`. | `partial`; chưa assert đúng lỗi duplicate email từng dòng. |
| 38 | システム管理者 | SA-I08 | アップロード失敗 — 同一テナント内でSIP番号が重複 | `tenantCsvInvalidDataRejectedWithErrorFile` | Upload invalid CSV và assert HTTP `4xx` trả tên error file `.csv`. | `partial`; chưa assert đúng lỗi SIP duplicate từng dòng. |
| 39 | システム管理者 | SA-I09 | エラーファイル修正後に再アップロード | `tenantCsvValidUploadOk` | Upload CSV hợp lệ tương ứng file đã sửa và assert user/account mapping được tạo. | `api-equivalent`; không cover thao tác download/sửa file trên UI. |
| 40 | システム管理者 | SA-I10 | アップロード失敗 — ファイルが50MB超 | `tenantCsvTooLargeRejected` | Upload CSV vượt giới hạn số dòng để assert backend reject ổn định. | `partial`; chưa dùng payload >50MB vì dễ gây broken pipe trong local harness. |
| 41 | システム管理者 | SA-I11 | アップロード失敗 — SIP番号が無効 | `tenantCsvInvalidDataRejected` | Upload invalid CSV có SIP invalid vào `/tenant/insert-user-csv` và assert HTTP `4xx`. | `partial`; chưa assert đúng từng rule SIP. |
| 42 | システム管理者 | SA-I12 | アップロード失敗 — SIP番号が無効 | `tenantCsvInvalidDataRejected` | Upload invalid CSV có SIP invalid vào `/tenant/insert-user-csv` và assert HTTP `4xx`. | `partial`; duplicate ID được map chung invalid CSV. |
| 43 | テナント管理者 | AUTH-01 | テナント管理者ログイン — OTP受信・入力成功 | `tenantAdminOtpLoginOk` | Login tenant admin, lấy preToken/OTP test flow và assert access token. | `api-equivalent`; OTP mail thật thay bằng test fixture/capture. |
| 44 | テナント管理者 | AUTH-02 | OTP期限切れ — OTP再送信成功 | `tenantAdminResendOtpOk` | Login tenant role lấy preToken, gọi `/auth/admin/resend-otp` và assert `200`. | `partial`; chưa assert OTP cũ hết hạn. |
| 45 | テナント管理者 | AUTH-03 | パスワード変更成功 | `tenantAdminChangePasswordOk` | Login tenant admin, gọi `/auth/admin/change-password`, sau đó login-with-role bằng password mới và assert preToken. | `api-equivalent`; không assert UI. |
| 46 | テナント管理者 | AUTH-04 | パスワード変更失敗 — 新しいパスワードが条件を満たさない | `tenantAdminWeakPasswordRejected` | Gọi `/auth/admin/change-password` với password yếu và assert HTTP `4xx`. | `negative-equivalent`. |
| 47 | テナント管理者 | AUTH-05 | メールOTPによるパスワード復旧 | `tenantAdminResetPasswordOk` | Gọi forgot-password, send-otp, đọc OTP trong `111_schema` rồi reset password và assert `200`. | `api-equivalent`; mail thật thay bằng DB/mail capture. |
| 48 | テナント管理者 | AUTH-06 | 5回連続ログイン失敗 | `tenantAdminWrongPasswordLockRejected` | Login-with-role password sai 5 lần, assert failure count/lock behavior và correct password bị reject. | `api-equivalent`; không assert text UI. |
| 49 | テナント管理者 | AUTH-10 | Nhập sai mã OTP 5 lần liên tiếp | `tenantAdminWrongOtpLockRejected` | Login tenant role lấy preToken, verify OTP sai 5 lần và assert HTTP `4xx`. | `api-equivalent`; không assert UI lock message. |
| 50 | テナント管理者 | TA-U01 | 一覧表示 ユーザー 後 ログイン | `usersListOk` | Gọi `/users/list` bằng tenant token và assert `200`. | `api-equivalent`; không assert route UI sau login. |
| 51 | テナント管理者 | TA-U02 | メールアドレスでユーザーを検索 | `usersSearchByEmailOk` | Gọi `/users/list` với `userName=active-user`, assert `200` và payload chứa `active-user`. | `api-equivalent`; không assert loại bỏ toàn bộ user không khớp. |
| 52 | テナント管理者 | TA-U03 | 氏名でユーザーを検索 | `usersSearchByNameOk` | Gọi `/users/list` với `fullName=Active` và assert `200`. | `api-equivalent`; chưa assert payload chỉ chứa tên khớp. |
| 53 | テナント管理者 | TA-U04 | 「利用中」状態でユーザーを絞り込む | `usersSearchActiveOk` | Gọi `/users/list` với status `3` và assert `200`. | `api-equivalent`; chưa assert tất cả rows đều active. |
| 54 | テナント管理者 | TA-U05 | 新規ユーザー追加成功（MVE API成功） | `userAddOk` | Gọi `/users/add` với user mới/SIP mới, assert user/account mapping được tạo. | `api-equivalent`; MVE success được stub, không assert UI. |
| 55 | テナント管理者 | TA-U06 | ユーザー追加失敗 — メールアドレスがシステム内に既に存在 | `userAddDuplicateEmailRejected` | Gọi `/users/add` với email đã tồn tại và assert HTTP `4xx`. | `negative-equivalent`. |
| 56 | テナント管理者 | TA-U07 | ユーザー追加失敗 — SIP番号がテナント内で使用済み | `userAddDuplicateSipRejected` | Gọi `/users/add` với SIP đã dùng và assert HTTP `4xx`. | `negative-equivalent`. |
| 57 | テナント管理者 | TA-U08 | ユーザー追加失敗 — 必須項目不足 | `userAddRequiredRejected` | Gọi `/users/add` thiếu required fields và assert HTTP `4xx`. | `negative-equivalent`. |
| 58 | テナント管理者 | TA-U09 | テナント種別ごとのSIP範囲を確認 | `userAddInvalidSipRejected` | Gọi `/users/add` với SIP ngoài range và assert HTTP `4xx`. | `negative-equivalent`; chưa cover cả hai loại tenant. |
| 59 | テナント管理者 | TA-U10 | ユーザー情報詳細を確認 | `userAdminDetailsOk` | Gọi `/users/admin-details?userUuid=active-user-uuid`, assert payload chứa email/họ tên fixture. | `api-equivalent`; không assert UI layout. |
| 60 | テナント管理者 | TA-U11 | 「削除済み」状態のユーザーで「編集」「削除」ボタンを確認 | `userDeletedDetailsOk` | Gọi `/users/admin-details?userUuid=deleted-user-uuid` và assert `200`. | `partial`; không assert button disabled/hidden. |
| 61 | テナント管理者 | TA-U12 | ユーザー情報編集 — 氏名を更新 | `userAdminUpdateOk` | Gọi `PUT /users/admin-update`, assert `200` và read-back DB field chính. | `api-equivalent`; chưa assert toàn bộ field UI. |
| 62 | テナント管理者 | TA-U13 | 「登録済み」ユーザーへ有効化メールを送信 | `sendActiveMailOk` | Gọi `/users/send-mail-active` cho `registered-user-uuid`, assert mail capture và DB status chuyển `2`. | `api-equivalent`; chưa assert HTML mail body. |
| 63 | テナント管理者 | TA-U14 | 「アクティブ待ち」ユーザーへ有効化メールを再送信 | `sendActiveMailResendOk` | Gọi `/users/send-mail-active` cho `waiting-user-uuid`, assert mail capture và status giữ active-wait. | `api-equivalent`; không assert UI warning. |
| 64 | テナント管理者 | TA-U15 | 「登録済み」「アクティブ待ち」以外の状態のユーザーには有効化メールを送信できない | `sendActiveMailInvalidStatusRejected` | Gọi `/users/send-mail-active` cho active user và assert HTTP `4xx`. | `api-equivalent`; cover backend reject, không assert checkbox disabled. |
| 65 | テナント管理者 | TA-U16 | 「戻る」ボタンでユーザー一覧へ戻る | `usersListOk` | Gọi `/users/list` và assert `200`. | `partial`; chỉ cover list endpoint, không cover browser back/navigation. |
| 66 | テナント管理者 | TA-U17 | ダウンロード テンプレート CSV から 画面 ユーザー一覧 | `usersCsvTemplateOk` | Gọi `/users/insert-user-csv/template` và assert byte response `200`. | `api-equivalent`; chưa assert filename/header. |
| 67 | テナント管理者 | TA-I01 | 有効なCSVアップロード — すべてのユーザーが作成される | `usersCsvValidUploadOk` | Upload CSV hợp lệ MS932/CRLF vào `/users/insert-user-csv`, assert user và account mapping được tạo. | `api-equivalent`; không assert browser file picker/progress UI. |
| 68 | テナント管理者 | TA-I02 | アップロード失敗 — ファイル未選択 | `usersCsvMissingFileRejected` | Upload empty bytes vào `/users/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`; không giống hoàn toàn no-file UI state. |
| 69 | テナント管理者 | TA-I03 | アップロード失敗 — ヘッダーのみでデータなし | `usersCsvEmptyRejected` | Upload empty CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`; chưa tạo CSV header-only đúng nghĩa. |
| 70 | テナント管理者 | TA-I04 | アップロード失敗 — データのみでヘッダーなし | `usersCsvBadHeaderRejected` | Upload CSV header sai vào `/users/insert-user-csv` và assert HTTP `4xx`. | `negative-equivalent`. |
| 71 | テナント管理者 | TA-I05 | アップロード 失敗 —姓 含む 特殊文字 ない 有効 | `usersCsvInvalidDataRejected` | Upload invalid CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `partial`; chưa assert đúng lỗi ký tự đặc biệt ở surname. |
| 72 | テナント管理者 | TA-I06 | アップロード失敗 — 姓カナにカタカナ以外を含む | `usersCsvInvalidDataRejected` | Upload invalid CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `partial`; chưa assert đúng lỗi kana. |
| 73 | テナント管理者 | TA-I07 | アップロード失敗 — SIP番号が4桁ではない（固定電話テナント） | `usersCsvInvalidDataRejected` | Upload invalid CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `partial`; chưa assert đúng lỗi digit count. |
| 74 | テナント管理者 | TA-I08 | アップロード失敗 — SIP番号が無効 | `usersCsvInvalidDataRejected` | Upload invalid CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `partial`; chưa assert đúng SIP range. |
| 75 | テナント管理者 | TA-I09 | アップロード失敗 — SIP番号が無効 | `usersCsvInvalidDataRejected` | Upload invalid CSV vào `/users/insert-user-csv` và assert HTTP `4xx`. | `partial`; duplicate invalid SIP case map chung. |
| 76 | テナント管理者 | TA-I10 | アップロード失敗 — 同一CSVファイル内でメールアドレスが重複 | `usersCsvInvalidDataRejectedWithErrorFile` | Upload invalid CSV và assert HTTP `4xx` trả tên error file `.csv`. | `partial`; chưa assert đúng duplicate email từng dòng. |
| 77 | テナント管理者 | TA-I11 | メンテナンス中にインポートが無効化されることを確認 | `usersCsvMaintenanceBlocksImport` | Start maintenance, check `data=true`, upload valid CSV và assert import bị reject. | `api-equivalent`; không assert UI disabled state. |
| 78 | テナント管理者 | TA-I12 | メンテナンス終了後にインポートが正常復旧する | `usersCsvMaintenanceRecoveredOk` | Start rồi stop maintenance, check `data=false`, upload valid CSV và assert `200`. | `api-equivalent`; không assert UI disabled state. |
| 79 | テナント管理者 | TA-D01 | ユーザー削除成功 | `userDeleteOk` | Gọi `/users/delete` cho `waiting-user-uuid` và assert `200`. | `api-equivalent`; chưa assert user app không login được. |
| 80 | テナント管理者 | TA-D02 | 「削除済み」ユーザーが一覧に表示され続けることを確認 | `usersSearchDeletedOk` | Gọi `/users/list` status `4`, assert payload chứa `deleted-user`. | `api-equivalent`; chưa assert disabled edit/delete UI. |
| 81 | テナント管理者 | TA-D03 | 岡田電機がメンテナンス実施後、SIPアカウントがMVEから削除される | `mveExportAccountOk` | Gọi `/mve-admin/export-account` và assert byte response `200`. | `partial`; chưa assert MVE import và SIP bị xóa. |
| 82 | 岡田電機管理者 | AUTH-02 | 岡田電機管理者が正常にログインする（IPホワイトリスト） | `mveAdminLoginOk` | Login MVE admin và assert access token được phát hành. | `api-equivalent`; không assert điều hướng UI tới MVE admin screen. |
| 83 | 岡田電機管理者 | AUTH-05 | ログイン失敗 — IPがホワイトリスト外（システム/岡田電機管理者） | `mveAdminIpDenied` | Override whitelist MVE admin thành IP khác, login MVE admin và assert `401 Unauthorized`. | `equivalent`; cover backend whitelist. |
| 84 | 岡田電機管理者 | OD-T01 | テナントIDでテナントを検索 | `mveTenantSearchByIdOk` | Gọi `/mve-admin/tenant` với `tenantId=111` và assert `200`. | `api-equivalent`; chưa assert only matched tenant. |
| 85 | 岡田電機管理者 | OD-T02 | IPGroup Nameでテナントを検索 | `mveTenantSearchByNameOk` | Gọi `/mve-admin/tenant` với `tenantName=Tenant` và assert `200`. | `api-equivalent`; tên method hiện search theo tenantName, không assert IPGroup name cụ thể. |
| 86 | 岡田電機管理者 | OD-T03 | 「登録待ち」テナントが一覧の先頭に優先表示されることを確認 | `mveWaitingTenantListOk` | Gọi `/mve-admin/list-waiting-tenant` với status `0` và assert `200`. | `partial`; chưa assert sort ưu tiên đầu list. |
| 87 | 岡田電機管理者 | OD-T04 | 「登録待ち」テナントのIPGroup Name作成完了を確認 | `mveNotifyIpGroupOk` | Gọi `/mve-admin/ip-group-name/notify-created` với tenant `112` và assert `200`. | `api-equivalent`; MVE/mail side effect được stub, chưa assert trạng thái user/tenant sau call. |
| 88 | 岡田電機管理者 | OD-T05 | IPGroup確認 — 「利用中」テナントではボタンが使用不可 | `mveTenantSearchByIdOk` | Gọi `/mve-admin/tenant` với tenant `111` và assert `200`. | `partial`; không assert button disabled cho tenant đang sử dụng. |
| 89 | 岡田電機管理者 | OD-T06 | 複数テナントのIPGroupを一括確認 | `mveNotifyIpGroupOk` | Gọi `/mve-admin/ip-group-name/notify-created` với list tenant chứa `112` và assert `200`. | `partial`; chưa cover nhiều tenant thật. |
| 90 | 岡田電機管理者 | OD-M01 | ポップアップで「キャンセル」をクリックした場合にメンテナンスをキャンセル | `mveCheckMaintainOk` | Gọi `/mve-admin/check-maintain` và assert `200`. | `partial`; không cover cancel popup và assert state unchanged. |
| 91 | 岡田電機管理者 | OD-M02 | メンテナンス開始 成功 | `mveStartMaintainOk` | Gọi `PUT /mve-admin/start-maintain` và assert `200`. | `api-equivalent`; không assert button visibility. |
| 92 | 岡田電機管理者 | OD-M03 | メンテナンス中にアプリの通話/メッセージが無効化される | `mveStartAndCheckMaintainOk` | Start maintenance, check `/mve-admin/check-maintain` trả `data=true`. | `partial`; không test mobile call/message disabled. |
| 93 | 岡田電機管理者 | OD-M04 | メンテナンス終了 成功 | `mveStopMaintainOk` | Start rồi stop maintenance bằng API và assert cả hai call `200`. | `api-equivalent`; không assert UI button restore/mobile recovery. |
| 94 | 岡田電機管理者 | OD-M06 | メンテナンス中にログアウト・再ログインしても状態は解除されない | `mveMaintainPersistsAfterLoginOk` | Start maintenance, login MVE admin lại, check maintain `data=true`. | `api-equivalent`; không assert browser logout/login UI. |
| 95 | 岡田電機管理者 | OD-E01 | SIPアカウント一覧CSVを出力 | `mveExportAccountOk` | Gọi `/mve-admin/export-account` và assert byte response `200`. | `api-equivalent`; chưa assert 4 cột CSV. |
| 96 | 岡田電機管理者 | OD-E02 | CSVファイルに有効状態のユーザーのみ含まれることを確認 | `mveExportAccountOk` | Gọi `/mve-admin/export-account`, assert CSV chứa active SIP và không chứa deleted user. | `api-equivalent`; không assert bằng Excel/UI. |
| 97 | 岡田電機管理者 | OD-E03 | CSVファイル内のデータ形式を確認 | `mveExportAccountOk` | Gọi `/mve-admin/export-account`, assert CSV chứa header/field `LocalUser`, `Username`, `Password`, `IPGroupName`. | `api-equivalent`; chưa assert mọi row. |
| 98 | 岡田電機管理者 | OD-E05 | CSVファイルをMVEへインポート — 「削除済み」ユーザーがMVEから削除される | `mveExportAccountOk` | Gọi `/mve-admin/export-account` và assert byte response `200`. | `partial`; chưa cover import vào MVE và xóa user. |
| 99 | 岡田電機管理者 | OD-E06 | ユーザー削除時のE2Eメンテナンス: 出力 → メンテナンス → MVEインポート → 終了 | `mveMaintenanceExportFlowOk` | Start maintenance, export account CSV, stop maintenance, assert các API `200`. | `partial`; chưa assert MVE import success và trạng thái SIP sau sync. |
| 100 | オンボーディングフロー | SA-OB01 | End-to-end: テナント作成 → アップロード ユーザー → 送信 メール テナント管理者 | `onboardingTenantMailFlowOk` | Search waiting tenant rồi gửi mail tenant admin, assert các API `200`. | `partial`; chưa cover tạo tenant/upload user thành công trong cùng flow. |
| 101 | オンボーディングフロー | SA-OB02 | テナント作成直後のユーザーアップロード手順をスキップ | `tenantDetailsOk` | Gọi `/tenant/details?tenantId=111` và assert `200`. | `partial`; không cover popup skip upload. |
| 102 | オンボーディングフロー | SA-OB03 | 岡田電機がIPGroup確認後、ユーザー状態が「登録済み」になることを確認 | `mveNotifyIpGroupOk` | Gọi `/mve-admin/ip-group-name/notify-created` với tenant `112` và assert `200`. | `partial`; chưa assert user status chuyển sang registered. |
| 103 | オンボーディングフロー | SA-OB04 | ユーザーのアカウント有効化確認 — 状態「利用中」 | `sendActiveMailOk` | Gọi `/users/send-mail-active` cho user registered và assert `200`. | `partial`; chưa cover user click activation link/mobile first login. |
| 104 | オンボーディングフロー | SA-OB05 | メール受信後にテナント管理者がログインできることを確認 | `tenantAdminOtpLoginOk` | Login tenant admin OTP flow và assert access token. | `api-equivalent`; không assert login từ nội dung mail. |

## Additional API IT Cases

Nhóm này gồm 6 API integration guard case bổ sung, không lấy trực tiếp từ testcase UI gốc nhưng đang nằm trong full suite `110` case để bảo vệ behavior auth/IP whitelist quan trọng.

| # | Test class | API IT method | Nội dung API IT đang kiểm thử | Coverage / gap |
| --- | --- | --- | --- | --- |
| 105 | `AuthIpWhitelistDeniedIT` | `systemAdminLoginReturnsUnauthorizedWhenIpIsNotWhitelisted` | Set whitelist system admin sang IP khác, gọi `/auth/admin/login` bằng system admin hợp lệ và assert HTTP `401 Unauthorized`. | `api-equivalent`; guard trực tiếp bug IP ngoài whitelist không được trả `500` hoặc login thành công. |
| 106 | `AuthIpWhitelistDeniedIT` | `multiRoleMasterSelectionReturnsUnauthorizedWhenIpIsNotWhitelisted` | Set whitelist system admin sang IP khác, gọi `/auth/admin/login-with-role` role `master_admin` của multi-role admin và assert HTTP `401 Unauthorized`. | `api-equivalent`; guard nhánh chọn role master admin khi IP không whitelist. |
| 107 | `AuthApiIT` | `systemAdminLoginReturnsAccessTokenWhenIpIsWhitelisted` | Gọi `/auth/admin/login` bằng system admin khi IP test nằm trong whitelist và assert access token được phát hành. | `api-equivalent`; smoke positive path cho system admin login. |
| 108 | `AuthApiIT` | `multiRoleLoginReturnsMasterAndTenantRoleChoices` | Gọi `/auth/admin/login` bằng multi-role admin và assert response trả đủ role choice `master_admin`, `tenant_admin`. | `api-equivalent`; bảo vệ contract chọn role trước khi phát token. |
| 109 | `AuthApiIT` | `multiRoleMasterSelectionReturnsAccessTokenWhenIpIsWhitelisted` | Gọi `/auth/admin/login-with-role` role `master_admin` bằng multi-role admin và assert access token được phát hành. | `api-equivalent`; smoke positive path cho master role selection. |
| 110 | `AuthApiIT` | `tenantRoleSelectionReturnsPreTokenAndStoresFixedOtp` | Gọi `/auth/admin/login-with-role` role `tenant_admin` với `tenantId=111` và assert preToken được phát hành. | `api-equivalent`; smoke positive path cho tenant role selection/OTP step. |

## Nhận xét coverage hiện tại

| Nhóm | Đánh giá |
| --- | --- |
| Auth/IP whitelist | Mạnh hơn trước; đã cover token issuance, OTP, password change/reset, whitelist deny, multi-role selection và lock 5 lần cho system/tenant admin. |
| Tenant management | Cover nhiều API chính, gồm tạo tenant success, update/read-back, delete, mail send/resend. Các case UI visibility vẫn partial. |
| CSV import/export | Cover template/download, success upload tạo user/account mapping, nhiều negative paths và error file name. File size >50MB đang dùng surrogate row-limit để tránh broken pipe local. |
| User management | Cover list/search/add/update/delete/send active mail backend. UI button state và mail/detail status read-back còn partial. |
| MVE/maintenance | Cover API start/stop/check/export và notify flow. Chưa cover MVE thật, mobile behavior và CSV import external system. |
| Onboarding | Có smoke flow qua API, nhưng chưa phải end-to-end đầy đủ từ tenant create đến activation/mobile login. |

## Kết luận

Full API IT suite hiện có `110` case: 104 case chuyển đổi từ testcase web gốc trong `VoipWebApiRegressionIT` và 6 API guard case bổ sung trong `AuthApiIT`/`AuthIpWhitelistDeniedIT`.

Bộ test này hiện chạy ổn định local, dùng để moi lỗi backend/API và side effect có thể kiểm soát bằng DB/stub. Nó không phải bộ UI automation TypeScript/Playwright và chưa thay thế hoàn toàn testcase UI gốc.

Nếu cần nâng coverage lên gần 1-1 với testcase gốc, ưu tiên tiếp theo là mở rộng các case đang đánh dấu `partial`, đặc biệt: tenant create success, CSV success/error file assertions, 5 lần lock, resend/active-wait mail behavior, maintenance import flow và các UI visibility cases.
