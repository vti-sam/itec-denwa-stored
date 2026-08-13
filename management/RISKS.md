---
schema_version: 3
table: risks
key: id
mode: replace
---

# リスク管理

| id | risk_type | title | description | status | priority | owner | probability | impact | mitigation | contingency | related_items | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-001 | Technical | 片方のアプリ強制終了またはネット切断時にVoIP通話がハングする可能性 | アプリ終了やネットワーク切断時に終了通知が届かず、通話がタイムアウトまで残る可能性がある。 | Monitor | Critical | VTI_SAM | High | High | Android/iOS/MVEのログを突合し、クライアントとサーバーの責任範囲を分けて確認する。 | サーバー/PBXのタイムアウトを適用し、制限事項をリリース資料に明記する。 | VoIP, Android, iOS, MVE | VOIP_APL-135でシステム制約として確認済み。 |
| R-002 | Technical | AudioCodes SDK/PJSIPのスレッドおよびセッションライフサイクルへの極端な感度 | スレッド境界、セッション状態またはSDK呼び出しのタイミングが不適切な場合、クラッシュや不安定動作が発生する可能性がある。 | Monitor | Critical | VTI_SAM | High | High | SDK操作を合意済みのスレッド/状態境界で実行し、sessionId・transferState・callStateを記録する。 | ログを添えてAudioCodes/MVEへエスカレーションし、対象フローの制限を検討する。 | Android, AudioCodes SDK, PJSIP, Jetpack Compose |  |
| R-003 | Technical | MVE/PBXの設計がモバイルアプリのライフサイクルに完全対応していない問題 | バックグラウンド、強制終了、Push通知、ネットワーク切替により、着信・通話・転送が不安定になる可能性がある。 | Completed | Critical | VTI_SAM | High | High | OS別の制限とMVE/SIPの前提を整理し、期待動作を合意する。 | クライアントで対応できない範囲を制限事項または代替運用として確定する。 | VoIP, Android, iOS, MVE, PBX |  |
| R-004 | Technical | コール転送/登録/ネットワーク切り替え処理の複数レイヤー依存によるデグレードリスク | 転送、再登録、ネットワーク切替、画面表示が連動するため、一部変更が他OSの動作に影響する可能性がある。 | Completed | High | VTI_SAM | Medium | High | Android/iOSの共通シナリオとSIP/MVEログを用いて変更前に影響を確認する。 | 影響範囲を分離してロールバックし、主要フローを優先して復旧する。 | Android, iOS, transfer, register, network-change |  |
