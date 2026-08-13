# テーブル定義書

## 表紙

| 項目 | 内容 |
| --- | --- |
| プロジェクト名 | ITEC Denwa |
| システム名称 | ぷらっとCALL |
| サブシステム名 | VoIPWeb / API |
| 作成者 | VTI |
| 作成日 | 2026/06/25 |

## テーブル一覧

| No | 物理テーブル名 | 備考 | 登録方法 | 移行方法 |
| --- | --- | --- | --- | --- |
| 1 | account_mapping | master schema |  |  |
| 2 | admin | master schema |  |  |
| 3 | maintain | master schema |  |  |
| 4 | otp | master schema |  |  |
| 5 | sip_accounts | master schema |  |  |
| 6 | system_settings | master schema |  |  |
| 7 | tenant_account_history | master schema |  |  |
| 8 | tenant_billing_info | master schema |  |  |
| 9 | tenant_contract_info | master schema |  |  |
| 10 | tenant_edit_history | master schema |  |  |
| 11 | tenants | master schema |  |  |
| 12 | admin | tenant schema |  |  |
| 13 | call_forward | tenant schema |  |  |
| 14 | calls | tenant schema |  |  |
| 15 | conversations | tenant schema |  |  |
| 16 | device_tokens | tenant schema |  |  |
| 17 | group_member | tenant schema |  |  |
| 18 | group_number | tenant schema |  |  |
| 19 | messages | tenant schema |  |  |
| 20 | otp | tenant schema |  |  |
| 21 | short_message | tenant schema |  |  |
| 22 | users | tenant schema |  |  |

## ERD

ERDは以下の図を参照する。

![DB-TABLE-01 テーブル定義書 ERD](DB-TABLE-01_テーブル定義書_ERD.png)

## 1. account_mapping (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | アカウントマッピング |
| RDBMS | PostgreSQL |
| 物理テーブル名 | account_mapping |
| 備考 | ユーザーアカウントとテナントを紐付けるマッピングテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | ユーザー名 | user_name | varchar(255) | Yes |  |  |
| 2 | テナント番号 | tenant_id | varchar(255) | Yes |  | 0: ADMIN; 1: USER |
| 3 | アカウントタイプ | account_type | varchar(1) | Yes |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | user_name, tenant_id, account_type | Yes | Yes |  |

## 2. admin (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | 管理者 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | admin |
| 備考 | 管理者アカウント情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 管理者UUID | admin_uuid | varchar(255) | Yes |  |  |
| 2 | 管理者名 | admin_name | varchar(255) | Yes |  |  |
| 3 | 管理者パスワード | admin_password | varchar(255) | Yes |  |  |
| 4 | 管理者氏名 | admin_full_name | text | Yes |  |  |
| 5 | 管理者氏名カナ | admin_full_name_kana | text | Yes |  |  |
| 6 | 権限 | role | varchar(1) | Yes |  | 0: SYSTEM_ADMIN; 1: TENANT_ADMIN; 2: USER; 3: MVE_ADMIN |
| 7 | 最終ログイン日時 | last_login_time | timestamp | No |  |  |
| 8 | 管理者電話番号 | admin_tel | varchar(20) | Yes |  |  |
| 9 | リフレッシュトークン | refresh_token | text | No |  |  |
| 10 | リフレッシュトークン有効期限 | refresh_token_expiry_time | timestamp | No |  |  |
| 11 | ログイン失敗回数 | login_failure_count | int4 | No |  |  |
| 12 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 13 | 作成日時 | created_date | timestamp | Yes |  |  |
| 14 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 15 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 16 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 17 | バージョン番号 | version_no | int8 | No |  |  |
| 18 | パスワード再設定ロック日時 | lock_reset_password_time | timestamp | No |  |  |
| 19 | パスワード再設定失敗回数 | reset_password_failure_count | int4 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | admin_uuid | Yes | Yes |  |

## 3. maintain (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | メンテナンス |
| RDBMS | PostgreSQL |
| 物理テーブル名 | maintain |
| 備考 | メンテナンス状態を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | メンテナンスUUID | maintain_uuid | varchar(255) | Yes |  |  |
| 2 | メンテナンス状態 | maintain_status | varchar(1) | Yes |  | 0: NOT_MAINTAIN; 1: MAINTAINING |
| 3 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 4 | 作成日時 | created_date | timestamp | Yes |  |  |
| 5 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 6 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 7 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 8 | バージョン番号 | version_no | int8 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | maintain_uuid | Yes | Yes |  |

## 4. otp (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | OTP |
| RDBMS | PostgreSQL |
| 物理テーブル名 | otp |
| 備考 | OTP認証コードを管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | OTP UUID | otp_uuid | varchar(255) | Yes |  |  |
| 2 | OTP種別 | otp_type | varchar(1) | Yes |  | 0: ぷらっとCALL認証コード; 1: ワンタイムパスワード |
| 3 | アカウント種別 | account_type | varchar(1) | Yes |  | 0: システム管理者; 1: ユーザー |
| 4 | アカウントID | account_id | varchar(255) | Yes |  |  |
| 5 | OTPコード | otp_code | varchar(6) | Yes |  |  |
| 6 | 使用済みフラグ | is_used | bool | Yes | false | false: 未使用; true: 使用済み |
| 7 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 8 | 有効期限 | expires_at | timestamp | Yes |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | otp_uuid | Yes | Yes |  |

## 5. sip_accounts (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 |  master_schema|
| 更新日 | 2026/06/25 |
| 論理テーブル名 | SIPアカウント |
| RDBMS | PostgreSQL |
| 物理テーブル名 | sip_accounts |
| 備考 | SIPアカウント情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | SIPアカウントUUID | sip_account_uuid | varchar(255) | Yes |  |  |
| 2 | SIPユーザー名 | sip_user_name | varchar(255) | Yes |  |  |
| 3 | SIPパスワード | sip_password | varchar(255) | Yes |  |  |
| 4 | テナントUUID | tenant_uuid | varchar(255) | No |  |  |
| 5 | SIP状態 | sip_status | varchar(1) | No |  |  |
| 6 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 7 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | sip_account_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | 参照先カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN_KEY | tenant_uuid | tenants | tenant_uuid |

## 6. system_settings (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | システム設定 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | system_settings |
| 備考 | MVEサーバー情報を管理するテーブル |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | システム設定UUID | system_setting_uuid | varchar(255) | Yes |  |  |
| 2 | IPアドレス | ip_address | varchar(60) | Yes |  |  |
| 3 | ドメイン | domain | varchar(60) | Yes |  |  |
| 4 | UDPポート | port_udp | varchar(10) | Yes |  |  |
| 5 | TLSポート | port_tls | varchar(10) | Yes |  |  |
| 6 | 作成者 | created_by | varchar(255) | No |  |  |
| 7 | 作成日時 | created_date | timestamp | No |  |  |
| 8 | 最終更新者 | last_modified_by | varchar(255) | No |  |  |
| 9 | 最終更新日時 | last_modified_date | timestamp | No |  |  |
| 10 | 削除フラグ | delete_flag | bit(1) | No | '0'::"bit" | 0: ACTIVE; 1: DELETED |
| 11 | バージョン番号 | version_no | int8 | No | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | system_setting_uuid | Yes | Yes |  |

## 7. tenant_account_history (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | テナントアカウント履歴 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | tenant_account_history |
| 備考 | テナントごとの利用ユーザー数変更履歴を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 履歴UUID | history_uuid | varchar(255) | Yes |  |  |
| 2 | テナントID | tenant_id | varchar(255) | Yes |  |  |
| 3 | 利用ユーザー数 | users_count | int8 | Yes |  |  |
| 4 | 変更日時 | changed_at | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 5 | 変更者 | changed_by | varchar(255) | Yes |  |  |
| 6 | 備考 | note | text | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | history_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | 参照先カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN_KEY | tenant_id | tenant_contract_info | tenant_id |

## 8. tenant_billing_info (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | テナント請求情報 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | tenant_billing_info |
| 備考 | テナントの請求先情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | テナントID | tenant_id | varchar(255) | Yes |  |  |
| 2 | 会社名 | company_name | varchar(255) | Yes |  |  |
| 3 | 住所 | address | varchar(255) | No |  |  |
| 4 | 代表電話番号 | main_phone_number | varchar(20) | No |  |  |
| 5 | 請求担当者名 | billing_contact_name | varchar(255) | Yes |  |  |
| 6 | 請求担当者電話番号 | billing_contact_phone_number | varchar(255) | No |  |  |
| 7 | 請求担当者メールアドレス | billing_contact_email | varchar(50) | No |  |  |
| 8 | 当月利用ユーザー数 | users_count_this_month | int8 | No |  |  |
| 9 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 10 | 作成日時 | created_date | timestamp | Yes |  |  |
| 11 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 12 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 13 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 14 | バージョン番号 | version_no | int8 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | tenant_id | Yes | Yes |  |

## 9. tenant_contract_info (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | テナント契約情報 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | tenant_contract_info |
| 備考 | テナントの契約情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | テナントID | tenant_id | varchar(255) | Yes |  |  |
| 2 | 会社名 | company_name | varchar(255) | Yes |  |  |
| 3 | 住所 | address | varchar(255) | No |  |  |
| 4 | 代表電話番号 | main_phone_number | varchar(20) | No |  |  |
| 5 | 管理者名 | administrator_name | varchar(255) | Yes |  |  |
| 6 | 管理者電話番号 | administrator_phone_number | varchar(255) | No |  |  |
| 7 | 管理者メールアドレス | administrator_email | varchar(50) | No |  |  |
| 8 | 申込時利用ユーザー数 | users_count_at_created_time | int8 | Yes |  |  |
| 9 | 予備ユーザー枠 | backup_users_count | int4 | No |  |  |
| 10 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 11 | 作成日時 | created_date | timestamp | Yes |  |  |
| 12 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 13 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 14 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 15 | バージョン番号 | version_no | int8 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | tenant_id | Yes | Yes |  |

## 10. tenant_edit_history (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | テナント編集履歴 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | tenant_edit_history |
| 備考 | テナント情報、契約情報、請求情報の編集履歴を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | テナント編集履歴UUID | tenant_edit_history_uuid | varchar(255) | Yes |  |  |
| 2 | テナントID | tenant_id | varchar(255) | No |  |  |
| 3 | 編集領域種別 | area_type | varchar(255) | No |  | 1: TENANT_INFO; 2: CONTRACT_INFO; 3: BILLING_INFO |
| 4 | 編集項目 | field | varchar(255) | No |  | 以下の列挙値が使用されます。 |
| 5 | 変更前値 | old_value | text | No |  |  |
| 6 | 変更後値 | new_value | text | No |  |  |
| 7 | 編集日時 | edited_at | timestamp | No |  |  |
| 8 | 編集者 | edited_by | varchar(255) | No |  |  |
| 9 | 管理者変更フラグ | is_change_admin | bool | No |  | false: 管理者変更なし; true: 管理者変更あり |

### 列挙値 (field)

| Value | Label | Enum |
| --- | --- | --- |
| 1 | テナント名 | TENANT_NAME |
| 2 | 会社名 | TCF_COMPANY_NAME |
| 3 | 住所 | TCF_ADDRESS |
| 4 | 代表電話番号 | TCF_MAIN_PHONE_NUMBER |
| 5 | 管理者名 | TCF_ADMINISTRATOR_NAME |
| 6 | 管理者電話番号 | TCF_ADMINISTRATOR_PHONE_NUMBER |
| 7 | 管理者メールアドレス | TCF_ADMINISTRATOR_EMAIL |
| 8 | 申込時利用ユーザー数 | TCF_USERS_COUNT_AT_CREATED_TIME |
| 9 | 予備ユーザー枠 | TCF_BACKUP_USERS_COUNT |
| 10 | 会社名 | TBI_COMPANY_NAME |
| 11 | 住所 | TBI_ADDRESS |
| 12 | 代表電話番号 | TBI_PHONE_NUMBER |
| 13 | 請求担当者名 | TBI_CONTACT_NAME |
| 14 | 請求担当者電話番号 | TBI_CONTACT_PHONE_NUMBER |
| 15 | 請求担当者メールアドレス | TBI_CONTACT_EMAIL |
| 16 | テナント状態 | STATUS |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | tenant_edit_history_uuid | Yes | Yes |  |

## 11. tenants (master schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | master_schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | テナント |
| RDBMS | PostgreSQL |
| 物理テーブル名 | tenants |
| 備考 | テナント情報、契約情報、請求情報の編集履歴を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | テナントUUID | tenant_uuid | varchar(255) | Yes |  |  |
| 2 | テナントID | tenant_id | varchar(255) | Yes |  |  |
| 3 | テナント名 | tenant_name | varchar(255) | Yes |  |  |
| 4 | テナント状態 | tenant_status | varchar(1) | Yes |  | 0: WAITING_FOR_IP_GROUP_NAME_CONFIGURATION; 1: ACTIVE; 2: SUSPENDED; 3: TERMINATED |
| 5 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 6 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 7 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 8 | 最終更新日時 | last_modified_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 9 | 削除フラグ | delete_flag | varchar(1) | Yes | '0'::character varying | 0: ACTIVE; 1: DELETED |
| 10 | バージョン番号 | version_no | int8 | Yes | 1 |  |
| 11 | 会社ロゴURL | company_logo_url | varchar(255) | No |  |  |
| 12 | メモ | memo | varchar(255) | No |  |  |
| 13 | 完了予定日 | expected_completion_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 14 | アップロード状態 | upload_status | varchar(1) | No |  | 0: アップロード済み・登録待ち; 1: 登録完了 |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | tenant_uuid | Yes | Yes |  |

## 12. call_forward (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | 転送設定 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | call_forward |
| 備考 | ユーザーの通話転送設定を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 転送設定UUID | call_forward_uuid | varchar(255) | No |  |  |
| 2 | ユーザーUUID | user_uuid | varchar(255) | No |  |  |
| 3 | 転送状態 | forward_status | varchar(1) | No |  | 0: 非アクティブ; 1: アクティブ |
| 4 | 電話番号 | phone_number | varchar(20) | Yes |  |  |
| 5 | 作成者 | created_by | varchar(255) | No |  |  |
| 6 | 作成日時 | created_date | timestamp | No |  |  |
| 7 | 最終更新者 | last_modified_by | varchar(255) | No |  |  |
| 8 | 最終更新日時 | last_modified_date | timestamp | No |  |  |
| 9 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 10 | バージョン番号 | version_no | int8 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |

## 13. calls (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | 通話 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | calls |
| 備考 | 通話履歴情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 通話UUID | call_uuid | varchar(255) | Yes |  |  |
| 2 | 発信者ID | caller_id | varchar(255) | No |  |  |
| 3 | 受信者ID | receiver_id | varchar(255) | No |  |  |
| 4 | 音声ファイルURL | voice_file_url | varchar(255) | No |  |  |
| 5 | 通話種別 | call_type | varchar(1) | Yes |  | 0: 音声; 1: ビデオ; 2: SIP |
| 6 | 開始日時 | start_time | timestamp | No |  |  |
| 7 | 応答日時 | accepted_time | timestamp | No |  |  |
| 8 | 終了日時 | end_time | timestamp | No |  |  |
| 9 | 発信者電話番号 | caller_tel | varchar(20) | Yes |  |  |
| 10 | 受信者電話番号 | receiver_tel | varchar(20) | Yes |  |  |
| 11 | 通話状態 | call_status | varchar(1) | Yes |  | 0: 不在着信; 1: 拒否; 2: 通話成功 |
| 12 | 削除日時 | deleted_at | timestamp | No |  |  |
| 13 | 発信者削除フラグ | caller_deleted | varchar(1) | No |  | 0: 有効; 1: 削除された |
| 14 | 受信者削除フラグ | receiver_deleted | varchar(1) | No |  | 0: 有効; 1: 削除された |
| 15 | 作成者 | created_by | varchar(255) | No |  |  |
| 16 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 17 | 最終更新者 | last_modified_by | varchar(255) | No |  |  |
| 18 | 最終更新日時 | last_modified_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 19 | 削除フラグ | delete_flag | varchar(1) | Yes | '0'::"bit" | 0: ACTIVE; 1: DELETED |
| 20 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | call_uuid | Yes | Yes |  |

## 14. device_tokens (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | デバイストークン |
| RDBMS | PostgreSQL |
| 物理テーブル名 | device_tokens |
| 備考 | ユーザー端末のプッシュ通知用デバイストークンを管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | デバイストークンUUID | device_token_uuid | varchar(255) | Yes |  |  |
| 2 | ユーザーUUID | user_uuid | varchar(255) | Yes |  |  |
| 3 | デバイストークン | device_token | text | Yes |  |  |
| 4 | プラットフォーム | platform | varchar(10) | Yes |  | ANDROID; IOS |
| 5 | デバイスID | device_id | varchar(255) | Yes |  |  |
| 6 | 有効フラグ | is_active | bool | Yes | true | false: 無効; true: 有効 |
| 7 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 8 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 9 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 10 | 最終更新日時 | last_modified_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 11 | 削除フラグ | delete_flag | varchar(1) | Yes | 0 | 0: ACTIVE; 1: DELETED |
| 12 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | device_token_uuid | Yes | Yes |  |

## 15. group_member (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | グループメンバー |
| RDBMS | PostgreSQL |
| 物理テーブル名 | group_member |
| 備考 | グループ番号とユーザーの紐付けを管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | グループID | group_id | varchar(4) | Yes |  |  |
| 2 | ユーザーUUID | user_uuid | varchar(255) | Yes |  |  |
| 3 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 4 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 5 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 6 | 最終更新日時 | last_modified_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 7 | 削除フラグ | delete_flag | varchar(1) | Yes | '0'::character varying | 0: ACTIVE; 1: DELETED |
| 8 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | group_id, user_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | 参照先カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN_KEY | group_id | group_number | group_id |
| 2 | FOREIGN_KEY | user_uuid | users | user_uuid |

## 16. group_number (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | グループ番号 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | group_number |
| 備考 | グループ番号情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | グループID | group_id | varchar(4) | Yes |  |  |
| 2 | グループ名 | group_name | varchar(50) | Yes |  |  |
| 3 | メモ | memo | text | No |  |  |
| 4 | 状態 | status | varchar(50) | Yes |  |  |
| 5 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 6 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 7 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 8 | 最終更新日時 | last_modified_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 9 | 削除フラグ | delete_flag | varchar(1) | Yes | 0 | 0: ACTIVE; 1: DELETED |
| 10 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | group_id | Yes | Yes |  |

## 17. users (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 |  tenant schema|
| 更新日 | 2026/06/25 |
| 論理テーブル名 | ユーザー |
| RDBMS | PostgreSQL |
| 物理テーブル名 | users |
| 備考 | システム内でアプリを使用しているユーザー情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | ユーザーUUID | user_uuid | varchar(255) | Yes |  |  |
| 2 | ユーザー名 | user_name | varchar(255) | Yes |  |  |
| 3 | ユーザーパスワード | user_password | varchar(255) | No |  |  |
| 4 | 名 | first_name | text | Yes |  |  |
| 5 | 姓 | last_name | text | Yes |  |  |
| 6 | 名カナ | first_name_kana | text | Yes |  |  |
| 7 | 姓カナ | last_name_kana | text | Yes |  |  |
| 8 | 権限 | role | varchar(1) | Yes |  | 0: SYSTEM_ADMIN; 1: TENANT_ADMIN; 2: USER; 3: MVE_ADMIN |
| 9 | 生年月日 | user_birthday | date | No |  |  |
| 10 | 性別 | user_sex | varchar(1) | No |  | 0: UNKNOWN; 1: MALE; 2: FEMALE |
| 11 | 住所 | user_address | text | No |  |  |
| 12 | アバターURL | avatar_url | text | No |  |  |
| 13 | 最終ログイン日時 | last_login_time | timestamp | No |  |  |
| 14 | ユーザー状態 | user_status | varchar(1) | Yes |  | 0: WAITING_FOR_IP_GROUP_NAME_CONFIGURATION; 1: ACTIVE; 2: SUSPENDED; 3: TERMINATED |
| 15 | メモ | memo | varchar(5000) | No |  |  |
| 16 | リフレッシュトークン | refresh_token | text | No |  |  |
| 17 | リフレッシュトークン有効期限 | refresh_token_expiry_time | timestamp | No |  |  |
| 18 | ログイン失敗回数 | login_failure_count | int4 | No |  |  |
| 19 | パスワード再設定失敗回数 | reset_password_failure_count | int4 | Yes | 0 |  |
| 20 | パスワード再設定ロック日時 | lock_reset_password_time | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 21 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 22 | 作成日時 | created_date | timestamp | Yes |  |  |
| 23 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 24 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 25 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 26 | 電話タイプ | phone_type | varchar(1) | No |  | 0: PHONE_TENANT; 1: SMART_PHONE; 2: GROUP_NUMBER; 3: LANDLINE_PHONE; 4: SIP_PHONE |
| 27 | バージョン番号 | version_no | int8 | No |  |  |
| 28 | オンライン状態 | is_online | bool | No | false | false: オフライン; true: オンライン |
| 29 | SIPユーザー名 | user_name_sip | varchar(255) | No |  |  |
| 30 | SIP表示名 | display_name_sip | varchar(255) | No |  |  |
| 31 | SIPパスワード | password_sip | varchar(255) | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | user_uuid | Yes | Yes |  |

## 18. conversations (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | Conversations |
| RDBMS | PostgreSQL |
| 物理テーブル名 | conversations |
| 備考 | 会話セッション情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 会話UUID | conversation_uuid | varchar(255) | Yes |  |  |
| 2 | 開始ユーザーID | initiator_id | varchar(255) | Yes |  |  |
| 3 | 応答ユーザーID | responder_id | varchar(255) | Yes |  |  |
| 4 | 既読フラグ | is_read | bool | No |  | false: 未読; true: 既読 |
| 5 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 6 | 作成日時 | created_date | timestamp | Yes |  |  |
| 7 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 8 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 9 | 削除フラグ | delete_flag | varchar(1) | Yes | 0 | 0: ACTIVE; 1: DELETED |
| 10 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | conversation_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | 参照先カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN KEY | initiator_id | users | user_uuid |
| 2 | FOREIGN KEY | responder_id | users | user_uuid |

## 19. messages (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | メッセージ |
| RDBMS | PostgreSQL |
| 物理テーブル名 | messages |
| 備考 | 会話内のメッセージ情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | メッセージUUID | message_uuid | varchar(255) | Yes |  |  |
| 2 | 会話UUID | conversation_uuid | varchar(255) | Yes |  |  |
| 3 | 送信者ID | sender_id | varchar(255) | Yes |  |  |
| 4 | メッセージ種別 | message_type | varchar(1) | No |  |  |
| 5 | 本文 | content | text | No |  |  |
| 6 | 画像URL | image_url | text | No |  |  |
| 7 | 状態 | status | varchar(1) | No |  | 0: NOT_SEND; 1: SENT |
| 8 | 削除日時 | deleted_at | timestamp | No |  |  |
| 9 | リコール者 | recalled_by | varchar(255) | No |  |  |
| 10 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 11 | 作成日時 | created_date | timestamp | Yes |  |  |
| 12 | 最終更新者 | last_modified_by | varchar(255) | No |  |  |
| 13 | 最終更新日時 | last_modified_date | timestamp | No |  |  |
| 14 | 削除フラグ | delete_flag | varchar(1) | Yes | 0 | 0: ACTIVE; 1: DELETED |
| 15 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | message_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN KEY | conversation_uuid | conversations | conversation_uuid |
| 2 | FOREIGN KEY | sender_id | users | user_uuid |

## 20. short_message (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | ショートメッセージ |
| RDBMS | PostgreSQL |
| 物理テーブル名 | short_message |
| 備考 | ユーザーの定型ショートメッセージを管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | ショートメッセージUUID | short_message_uuid | varchar(255) | Yes |  |  |
| 2 | ユーザーID | user_id | varchar(255) | Yes |  |  |
| 3 | 内容 | content | varchar(255) | No |  |  |
| 4 | デフォルトフラグ | check_default | bool | No |  | false: 通常; true: デフォルト |
| 5 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 6 | 作成日時 | created_date | timestamp | Yes |  |  |
| 7 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 8 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 9 | 削除フラグ | delete_flag | varchar(1) | Yes | 0 | 0: ACTIVE; 1: DELETED |
| 10 | バージョン番号 | version_no | int8 | Yes | 1 |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | short_message_uuid | Yes | Yes |  |

### 外部キー情報

| No | 外部キー名 | カラムリスト | 参照先テーブル名 | カラムリスト |
| --- | --- | --- | --- | --- |
| 1 | FOREIGN KEY | user_id | users | user_uuid |

## 21. otp (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | OTP |
| RDBMS | PostgreSQL |
| 物理テーブル名 | otp |
| 備考 | OTP認証コードを管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | OTP UUID | otp_uuid | varchar(255) | Yes |  |  |
| 2 | OTP種別 | otp_type | varchar(1) | Yes |  | 0: ぷらっとCALL認証コード; 1: ワンタイムパスワード |
| 3 | アカウント種別 | account_type | varchar(1) | Yes |  | 0: システム管理者; 1: ユーザー |
| 4 | アカウントID | account_id | varchar(255) | Yes |  |  |
| 5 | OTPコード | otp_code | varchar(6) | Yes |  |  |
| 6 | 使用済みフラグ | is_used | bool | Yes | false | false: 未使用; true: 使用済み |
| 7 | 作成日時 | created_date | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 8 | 有効期限 | expires_at | timestamp | Yes |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | otp_uuid | Yes | Yes |  |

## 22. admin (tenant schema)

### テーブル情報

| 項目 | 内容 |
| --- | --- |
| システム名 | ぷらっとCALL |
| 作成者 | VTI |
| サブシステム名 | VoIPWeb / API |
| 作成日 | 2026/06/25 |
| スキーマ名 | tenant schema |
| 更新日 | 2026/06/25 |
| 論理テーブル名 | 管理者 |
| RDBMS | PostgreSQL |
| 物理テーブル名 | admin |
| 備考 | 管理者アカウント情報を管理するテーブル。 |

### カラム情報

| No | 論理名 | 物理名 | データ型 | Not Null | デフォルト | 備考 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 管理者UUID | admin_uuid | varchar(255) | Yes |  |  |
| 2 | 管理者名 | admin_name | varchar(255) | Yes |  |  |
| 3 | 管理者パスワード | admin_password | varchar(255) | Yes |  |  |
| 4 | 管理者氏名 | admin_full_name | text | Yes |  |  |
| 5 | 管理者氏名カナ | admin_full_name_kana | text | Yes |  |  |
| 6 | 権限 | role | varchar(1) | Yes |  | 0: SYSTEM_ADMIN; 1: TENANT_ADMIN; 2: USER; 3: MVE_ADMIN |
| 7 | 最終ログイン日時 | last_login_time | timestamp | No |  |  |
| 8 | 管理者電話番号 | admin_tel | varchar(20) | No |  |  |
| 9 | リフレッシュトークン | refresh_token | text | No |  |  |
| 10 | リフレッシュトークン有効期限 | refresh_token_expiry_time | timestamp | No |  |  |
| 11 | ログイン失敗回数 | login_failure_count | int4 | No |  |  |
| 12 | パスワード再設定失敗回数 | reset_password_failure_count | int4 | Yes | 0 |  |
| 13 | パスワード再設定ロック日時 | lock_reset_password_time | timestamp | Yes | CURRENT_TIMESTAMP |  |
| 14 | メール送信済み | mail_sent | varchar(1) | Yes |  | 0: NOT_SEND; 1: SENT |
| 15 | 作成者 | created_by | varchar(255) | Yes |  |  |
| 16 | 作成日時 | created_date | timestamp | Yes |  |  |
| 17 | 最終更新者 | last_modified_by | varchar(255) | Yes |  |  |
| 18 | 最終更新日時 | last_modified_date | timestamp | Yes |  |  |
| 19 | 削除フラグ | delete_flag | varchar(1) | No |  | 0: ACTIVE; 1: DELETED |
| 20 | バージョン番号 | version_no | int8 | No |  |  |

### インデックス情報

| No | インデックス名 | カラムリスト | 主キー | ユニーク | 備考 |
| --- | --- | --- | --- | --- | --- |
| 1 | PRIMARY | admin_uuid | Yes | Yes |  |
