# API結合テスト実行結果サマリー

- 作成日時: 2026/06/20 14:36
- 対象: VoIP Web API結合テスト
- 実行コマンド: `DOCKER_HOST=unix:///Users/vti-sam/.colima/default/docker.sock TESTCONTAINERS_RYUK_DISABLED=true bash ./mvnw -Papi-it verify`
- 実行環境: local / Colima Docker / Testcontainers PostgreSQL

| 実行回 | Tests | Failures | Errors | Skipped | 判定 | Mavenログ | Failsafeレポート |
| --- | ---: | ---: | ---: | ---: | --- | --- | --- |
| 第1回 | 110 | 0 | 0 | 0 | Pass | `VoIPWebAPI結合テストエビデンス/TEST-IT-EVD-01_第1回Mavenログ.txt` | `VoIPWebAPI結合テストエビデンス/TEST-IT-EVD-02_第1回Failsafeレポート` |
| 第2回 | 110 | 0 | 0 | 0 | Pass | `VoIPWebAPI結合テストエビデンス/TEST-IT-EVD-03_第2回Mavenログ.txt` | `VoIPWebAPI結合テストエビデンス/TEST-IT-EVD-04_第2回Failsafeレポート` |
