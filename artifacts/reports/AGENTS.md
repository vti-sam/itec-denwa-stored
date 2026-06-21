# AGENTS.md

- `project-store/artifacts/reports/` chỉ chứa các category folder theo loại tài liệu hoặc workflow tài liệu; không đặt report bundle đơn lẻ trực tiếp dưới folder này.
- Category folder phải được đặt bằng tên loại tài liệu ổn định, dạng kebab-case ASCII, ví dụ `architecture/`, `release/`, `security/`, `testcases/`.
- Report bundle folder dùng dạng `<document_id>_<document_title>/`, trong đó `<document_id>` là mã tài liệu ổn định và `<document_title>` là tên tài liệu tiếng Nhật.
- Folder chứa trực tiếp một tài liệu chính phải trùng basename với file chính, hoặc dùng tên cụm tài liệu tiếng Nhật khi bundle chứa nhiều file cùng một cụm nghĩa.
- File tài liệu chính phải dùng basename dạng `<document_id>_<document_title>_<document_kind>`, trong đó `<document_title>` và `<document_kind>` là tiếng Nhật; mã tài liệu, mã model, mã thiết bị hoặc thuật ngữ chuẩn đã được source-of-truth định nghĩa có thể giữ nguyên.
- Mã tài liệu phải thể hiện loại tài liệu trước, sau đó mới đến phạm vi/domain; không dùng mã sản phẩm hoặc domain thay cho loại tài liệu.
- Mã tài liệu cấp file dùng dạng `<doc_type>-<domain>-<seq2>` hoặc `<doc_type>-<phase>-<domain>-<seq2>` khi loại tài liệu cần phase. `seq2` là số thứ tự 2 chữ số trong cùng nhóm.
- Mã tài liệu cấp bundle dùng cùng quy tắc nhưng có thể bỏ domain khi bundle gom nhiều tài liệu con cùng loại và cùng title nhóm.
- Code loại tài liệu chuẩn trong subtree này: `ARCH` = 構造設計書, `REL` = リリース計画書またはチェックリスト, `SEC` = セキュリティレポート, `TC` = テストケース.
- Code phase testcase chuẩn: `UT` = 単体テスト, `IT` = 結合テスト, `ST` = システムテスト, `UAT` = 受入テスト. Trong testcase, `IT` luôn nghĩa là 結合テスト, không dùng để chỉ Information Technology.
- Code domain chuẩn phải là ASCII uppercase ổn định và có nghĩa nghiệp vụ/kỹ thuật rõ, ví dụ `INFRA`, `STORE`, `DEPLOY`, `WEB`, `API`, `MOB`.
- Các bản xuất cùng nội dung nhưng khác định dạng phải giữ cùng basename và chỉ khác extension; nếu cần gom theo định dạng, dùng subfolder như `excel/`.
- Không dùng tên class, component, agent, workaround hoặc mô tả tiếng Anh làm title chính của filename/folder nếu đã có tên tài liệu tiếng Nhật tương ứng.
- Khi di chuyển hoặc đổi tên report artifact, cập nhật link nội bộ trong `project-store/` trỏ tới đường dẫn hoặc filename cũ.
