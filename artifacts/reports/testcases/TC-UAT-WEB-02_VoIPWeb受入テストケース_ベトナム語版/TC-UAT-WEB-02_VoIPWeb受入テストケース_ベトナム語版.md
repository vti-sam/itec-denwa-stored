# TC-UAT-WEB-02 テストケース — VoIPWeb受入テストケース ベトナム語版

## @meta
プロジェクト名: ITEC Denwa
モジュール: VoIPWeb
段階: 受入テスト
作成者: VTI-SAM
作成日: 2026/06/20
作成日時: 2026/06/20 13:33
環境: DEV / PRD
分類値: N,A,B
ラウンド1名: 第1回（DEV）
ラウンド2名: 第2回（PRD）

## テストケース {sheet=VoIPWeb受入テスト越語版}
### UAT-WEB-001 Quản trị viên hệ thống đăng nhập thành công (IP whitelist)
ID: UAT-WEB-001
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Quản trị viên hệ thống đăng nhập thành công (IP whitelist)
前提条件:
Tài khoản quản trị viên hệ thống hợp lệ. IP đã được đăng ký trong whitelist.
実行手順:
① 第1回（DEV）: truy cập https://dev.apl.purattocall.com/admin/login
   第2回（PRD）: truy cập https://apl.purattocall.com/admin/login
② Nhập email và mật khẩu hợp lệ
③ Nhấn "ログイン"
期待される結果:
Chuyển trực tiếp đến màn hình danh sách tenant và màn hình OTP không hiển thị.
種別: N


### UAT-WEB-002 Đăng nhập thất bại - sai mật khẩu
ID: UAT-WEB-002
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Đăng nhập thất bại - sai mật khẩu
前提条件:
Trong hệ thống có tài khoản hợp lệ.
実行手順:
① Nhập email đúng và mật khẩu sai
② Nhấn "ログイン"
期待される結果:
Thông báo lỗi hiển thị và màn hình không chuyển. Nếu nhập sai 5 lần liên tiếp, tài khoản bị khóa.
種別: A


### UAT-WEB-003 Đăng nhập thất bại - IP ngoài whitelist (quản trị viên hệ thống/Okada Denki)
ID: UAT-WEB-003
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Đăng nhập thất bại - IP ngoài whitelist (quản trị viên hệ thống/Okada Denki)
前提条件:
IP hiện tại chưa được đăng ký trong whitelist.
実行手順:
① Nhập thông tin đăng nhập hợp lệ của quản trị viên hệ thống
② Nhấn "ログイン"
期待される結果:
Thông báo lỗi IP không được phép hiển thị và truy cập bị từ chối.
種別: N


### UAT-WEB-004 Đổi mật khẩu thành công
ID: UAT-WEB-004
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Đổi mật khẩu thành công
前提条件:
Đã đăng nhập bằng một role bất kỳ.
実行手順:
① Nhấn tên người dùng ở góc trên bên phải, sau đó nhấn "パスワード変更"
② Nhập mật khẩu hiện tại
③ Nhập mật khẩu mới (tối thiểu 8 ký tự, có chữ hoa, số và ký tự đặc biệt)
④ Nhập lại mật khẩu mới để xác nhận
⑤ Nhấn "確認"
期待される結果:
Mật khẩu được cập nhật thành công và có thể đăng nhập bằng mật khẩu mới.
種別: N


### UAT-WEB-005 Đổi mật khẩu thất bại - mật khẩu mới không đáp ứng điều kiện
ID: UAT-WEB-005
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Đổi mật khẩu thất bại - mật khẩu mới không đáp ứng điều kiện
前提条件:
Đã đăng nhập.
実行手順:
① Nhấn "パスワード変更"
② Nhập mật khẩu mới chỉ gồm chữ thường (không có chữ hoa, số và ký tự đặc biệt)
③ Nhấn "確認"
期待される結果:
Lỗi validation hiển thị và mật khẩu không được cập nhật.
種別: A


### UAT-WEB-006 Khôi phục mật khẩu bằng OTP qua email
ID: UAT-WEB-006
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Khôi phục mật khẩu bằng OTP qua email
前提条件:
Trong hệ thống có tài khoản.
実行手順:
① Nhấn "パスワードをお忘れの方"
② Nhập email đã đăng ký
③ Nhấn "送信"
④ Nhập mật khẩu mới
⑤ Nhấn "コード送信"
⑥ Nhập OTP nhận được qua email và nhấn "確認"
期待される結果:
Mật khẩu được đặt lại thành công và có thể đăng nhập bằng mật khẩu mới.
種別: N


### UAT-WEB-007 Nhập sai OTP 5 lần liên tiếp khi đặt lại mật khẩu
ID: UAT-WEB-007
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Nhập sai OTP 5 lần liên tiếp khi đặt lại mật khẩu
前提条件:
Trong hệ thống có tài khoản hợp lệ.
実行手順:
① Nhấn "パスワードをお忘れの方"
② Nhập email đã đăng ký
③ Nhấn "送信"
④ Nhập mật khẩu mới
⑤ Nhấn "コード送信"
⑥ Nhập mã OTP không hợp lệ
⑦ Nhấn nút "確認" 5 lần liên tiếp
期待される結果:
Hiển thị lỗi: "認証に失敗しました。誤った入力が多すぎたため、パスワード再設定のリクエストは無効となりました。10分後に再度お試しください。"
Chức năng đặt lại mật khẩu bị khóa trong 10 phút.
Một email thông báo được gửi cho người dùng.
種別: A


### UAT-WEB-008 Thực hiện lại đặt lại mật khẩu trong thời gian khóa sau khi nhập sai OTP 5 lần liên tiếp
ID: UAT-WEB-008
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Thực hiện lại đặt lại mật khẩu trong thời gian khóa sau khi nhập sai OTP 5 lần liên tiếp
前提条件:
Tài khoản đang bị khóa chức năng đặt lại mật khẩu.
実行手順:
① Nhấn "パスワードをお忘れの方"
② Nhập email đã đăng ký
③ Nhấn "送信"
期待される結果:
Hiển thị lỗi: "あなたのアカウントのパスワードリセット機能が{0}までロックされています。"
{0} hiển thị thời điểm mở khóa chức năng đặt lại mật khẩu (ví dụ: 10:30).
種別: N


### UAT-WEB-009 Đăng nhập thất bại 5 lần liên tiếp
ID: UAT-WEB-009
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Đăng nhập và bảo mật
中項目: Đăng nhập thất bại 5 lần liên tiếp
前提条件:
Trong hệ thống có tài khoản hợp lệ.
実行手順:
① Nhập email đúng và mật khẩu sai
② Thực hiện 5 lần liên tiếp
③ Nhấn "ログイン"
期待される結果:
Nếu nhập sai 5 lần liên tiếp, tài khoản bị khóa.
Có thể đặt lại mật khẩu bằng chức năng đặt lại mật khẩu.
種別: N


### UAT-WEB-010 Tạo tenant mới - tenant sử dụng điện thoại cố định
ID: UAT-WEB-010
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tạo tenant mới - tenant sử dụng điện thoại cố định
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Nhấn "テナント作成"
② Tick chọn checkbox "固定電話利用する"
③ Nhập mã tenant trong phạm vi 111-154
④ Nhập tên tenant và logo công ty
⑤ Nhập thông tin hợp đồng và thông tin thanh toán
⑥ Nhập ít nhất 1 quản trị viên tenant
⑦ Nhấn "保存" -> "OK"
期待される結果:
Tenant được tạo ở trạng thái "登録待ち".
Popup xác nhận upload người dùng hiển thị.
Ghi chú: chức năng upload người dùng được kiểm tra ở testcase "ユーザーインポート" bên dưới.
種別: N


### UAT-WEB-011 Tạo tenant mới - không sử dụng điện thoại cố định
ID: UAT-WEB-011
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tạo tenant mới - không sử dụng điện thoại cố định
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Nhấn "テナント作成"
② Không tick checkbox "固定電話利用する"
③ Nhập mã tenant trong phạm vi 500-999
④ Nhập tất cả trường bắt buộc
⑤ Nhấn "保存" -> "OK"
期待される結果:
Tenant được tạo ở trạng thái "登録待ち".
Popup xác nhận upload người dùng hiển thị.
Ghi chú: chức năng upload người dùng được kiểm tra ở testcase "ユーザーインポート" bên dưới.
種別: N


### UAT-WEB-012 Tạo tenant thất bại - mã tenant ngoài phạm vi (điện thoại cố định)
ID: UAT-WEB-012
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tạo tenant thất bại - mã tenant ngoài phạm vi (điện thoại cố định)
前提条件:
Đã đăng nhập bằng quản trị viên hệ thống. Đã tick "固定電話利用する".
実行手順:
① Nhấn "テナント作成" và tick checkbox điện thoại cố định
② Nhập mã tenant = 500 (ngoài phạm vi 111-154)
③ Nhấn "保存"
期待される結果:
Lỗi validation hiển thị và tenant không được tạo.
種別: A


### UAT-WEB-013 Tạo tenant thất bại - thiếu quản trị viên tenant
ID: UAT-WEB-013
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tạo tenant thất bại - thiếu quản trị viên tenant
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Nhập toàn bộ thông tin tenant
② Không nhập thông tin quản trị viên tenant
③ Nhấn "保存"
期待される結果:
Lỗi validation hiển thị với nội dung bắt buộc nhập ít nhất 1 quản trị viên tenant và tenant không được tạo.
種別: A


### UAT-WEB-014 Tìm kiếm tenant theo tên tenant
ID: UAT-WEB-014
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tìm kiếm tenant theo tên tenant
前提条件:
Trong hệ thống có ít nhất 2 tenant.
実行手順:
① Trên màn hình danh sách tenant, nhập tên tenant vào ô tên tenant
② Nhấn "検索"
期待される結果:
Chỉ tenant khớp với tên được hiển thị trong danh sách, các tenant khác bị ẩn.
種別: N


### UAT-WEB-015 Lọc tenant theo trạng thái "登録待ち"
ID: UAT-WEB-015
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Lọc tenant theo trạng thái "登録待ち"
前提条件:
Tồn tại tenant ở trạng thái "登録待ち".
実行手順:
① Trên màn hình danh sách tenant, chọn "登録待ち" trong dropdown trạng thái
② Nhấn "検索"
期待される結果:
Chỉ tenant ở trạng thái "登録待ち" được hiển thị.
種別: N


### UAT-WEB-016 Kiểm tra chi tiết thông tin tenant
ID: UAT-WEB-016
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kiểm tra chi tiết thông tin tenant
前提条件:
Trong hệ thống có ít nhất 1 tenant.
実行手順:
① Trên màn hình danh sách tenant, nhấn vào dòng tenant trong danh sách
期待される結果:
Màn hình chi tiết tenant hiển thị thông tin tenant, thông tin hợp đồng, thông tin thanh toán và thông tin quản trị viên tenant; có nút "編集" và "削除".
種別: N


### UAT-WEB-017 Hiển thị danh sách người dùng trong tenant (popup xem)
ID: UAT-WEB-017
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Hiển thị danh sách người dùng trong tenant (popup xem)
前提条件:
Tenant có ít nhất 1 người dùng.
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn nút "ビュー" trong phần danh sách người dùng
期待される結果:
Popup hiển thị danh sách người dùng gồm email, họ tên, trạng thái và số SIP.
種別: N


### UAT-WEB-018 Kiểm tra lịch sử số lượng người dùng trong tháng hiện tại
ID: UAT-WEB-018
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kiểm tra lịch sử số lượng người dùng trong tháng hiện tại
前提条件:
Tenant có lịch sử người dùng (số người dùng sử dụng trong tháng hiện tại).
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn icon lịch sử cạnh mục "当月利用ユーザー数"
期待される結果:
Popup hiển thị lịch sử thay đổi người dùng theo ngày trong tháng hiện tại.
Chỉ người dùng ở các trạng thái sau được tính vào "当月利用ユーザー数".
+ アクティブ待ち
+ 利用中
* Người dùng ở trạng thái "削除済み" không được tính.
種別: N


### UAT-WEB-019 Chỉnh sửa thông tin hợp đồng tenant
ID: UAT-WEB-019
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Chỉnh sửa thông tin hợp đồng tenant
前提条件:
Tenant ở trạng thái "利用中".
実行手順:
① Mở màn hình chi tiết tenant và nhấn "編集"
② Sửa tên công ty trong thông tin hợp đồng
③ Nhấn "保存"
期待される結果:
Thông tin được cập nhật. Không thể thay đổi mã tenant và trạng thái tenant.
種別: N


### UAT-WEB-020 Kiểm tra lịch sử chỉnh sửa tenant
ID: UAT-WEB-020
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kiểm tra lịch sử chỉnh sửa tenant
前提条件:
Tenant đã được chỉnh sửa ít nhất 1 lần.
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn nút "編集履歴"
期待される結果:
Popup hiển thị bảng lịch sử gồm khu vực, mục, nội dung trước chỉnh sửa, nội dung sau chỉnh sửa, ngày chỉnh sửa và người chỉnh sửa.
種別: N


### UAT-WEB-021 Dừng tenant đang ở trạng thái "利用中"
ID: UAT-WEB-021
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Dừng tenant đang ở trạng thái "利用中"
前提条件:
Tenant ở trạng thái "利用中".
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn "停止する" và xác nhận
期待される結果:
Trạng thái chuyển từ "利用中" sang "停止" và toàn bộ người dùng trong tenant không thể đăng nhập app.
種別: N


### UAT-WEB-022 Kiểm tra nút "停止する" không hiển thị khi tenant ở trạng thái "停止"
ID: UAT-WEB-022
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kiểm tra nút "停止する" không hiển thị khi tenant ở trạng thái "停止"
前提条件:
Tenant ở trạng thái "停止".
実行手順:
① Mở màn hình chi tiết tenant có trạng thái "停止"
期待される結果:
Nút "停止する" không hiển thị, chỉ hiển thị "有効化する".
種別: B


### UAT-WEB-023 Kích hoạt lại tenant ở trạng thái "停止"
ID: UAT-WEB-023
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kích hoạt lại tenant ở trạng thái "停止"
前提条件:
Tenant ở trạng thái "停止".
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn "有効化する" và xác nhận
期待される結果:
Trạng thái chuyển từ "停止" sang "利用中" và người dùng có thể đăng nhập app trở lại.
種別: N


### UAT-WEB-024 Xóa tenant
ID: UAT-WEB-024
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Xóa tenant
前提条件:
Tenant ở trạng thái "登録待ち", "利用中" hoặc "停止".
実行手順:
① Mở màn hình chi tiết tenant
② Nhấn "削除" và xác nhận
期待される結果:
Trạng thái chuyển thành "契約解除"; quản trị viên tenant không thể đăng nhập màn hình quản trị web và người dùng không thể đăng nhập app.
種別: N


### UAT-WEB-025 Gửi thông tin đăng nhập cho quản trị viên tenant
ID: UAT-WEB-025
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Gửi thông tin đăng nhập cho quản trị viên tenant
前提条件:
Tenant mới được tạo và thông tin đăng nhập chưa từng được gửi cho tài khoản quản trị viên tenant.
実行手順:
① Chọn tenant bằng checkbox
② Nhấn "ログイン情報通知" -> nhấn "OK"
期待される結果:
Email chứa URL đăng nhập và thông tin tài khoản được gửi cho quản trị viên tenant.
種別: N


### UAT-WEB-026 Không gửi lại cho quản trị viên tenant đã nhận email
ID: UAT-WEB-026
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Không gửi lại cho quản trị viên tenant đã nhận email
前提条件:
Quản trị viên tenant đã nhận email đăng nhập 1 lần.
実行手順:
① Chọn checkbox của tenant mục tiêu
② Nhấn "ログイン情報通知"
期待される結果:
Quản trị viên tenant đã từng nhận email đăng nhập được loại khỏi đối tượng gửi và email không được gửi lại.
種別: N


### UAT-WEB-027 Xuất danh sách tenant ra CSV
ID: UAT-WEB-027
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Xuất danh sách tenant ra CSV
前提条件:
Trong hệ thống có ít nhất 2 tenant.
実行手順:
① Chọn nhiều tenant bằng checkbox
② Nhấn "CSV出力"
期待される結果:
File CSV tên tenantyyyyMMdd_hhmmss.csv được tải xuống và chứa toàn bộ thông tin tenant, thông tin hợp đồng và thông tin thanh toán.
種別: N


### UAT-WEB-028 Khởi động batch thủ công để đồng bộ trạng thái người dùng
ID: UAT-WEB-028
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Khởi động batch thủ công để đồng bộ trạng thái người dùng
前提条件:
Có người dùng ở trạng thái "登録待ち" và có tài khoản SIP trên MVE.
実行手順:
① Trên màn hình danh sách tenant, nhấn "手動起動"
② Kiểm tra popup
期待される結果:
Người dùng có SIP trên MVE được cập nhật trạng thái thành "登録済み" và email thông báo kết quả được gửi cho quản trị viên tenant.
種別: B


### UAT-WEB-029 Kiểm tra người dùng "削除済み" bằng batch tự động
ID: UAT-WEB-029
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Kiểm tra người dùng "削除済み" bằng batch tự động
前提条件:
Có người dùng ở trạng thái "削除済み" và tài khoản SIP đã được xóa khỏi MVE.
実行手順:
Chờ batch tự động lúc 00:00 chạy hoặc khởi động thủ công.
期待される結果:
Nếu SIP của người dùng "削除済み" không tồn tại trên MVE, thông tin SIP bị xóa khỏi database.
Khi kiểm tra trên màn hình danh sách người dùng, người dùng đã xóa không còn liên kết với số SIP.
種別: B


### UAT-WEB-030 Tải xuống template CSV import người dùng
ID: UAT-WEB-030
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Quản lý tenant
中項目: Tải xuống template CSV import người dùng
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Trên màn hình danh sách tenant, nhấn "CSVテンプレートダウンロード"
期待される結果:
File người dùng.csv có header đúng định dạng được tải xuống.
種別: N


### UAT-WEB-031 Kiểm tra chuyển đến màn hình import người dùng bằng role quản trị viên hệ thống
ID: UAT-WEB-031
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Kiểm tra chuyển đến màn hình import người dùng bằng role quản trị viên hệ thống
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Nhấn "テナント作成"
② Tick "固定電話利用する"
③ Nhập mã tenant trong phạm vi 111-154
④ Nhập tên tenant và logo công ty
⑤ Nhập thông tin hợp đồng và thông tin thanh toán
⑥ Nhập ít nhất 1 quản trị viên tenant
⑦ Nhấn "保存" -> "OK"
⑧ Tại popup "ユーザー一括アップロード確認", nhấn "はい"
期待される結果:
Màn hình "ユーザー一括アップロード" hiển thị.
種別: B


### UAT-WEB-032 Kiểm tra chuyển đến màn hình import người dùng bằng role quản trị viên hệ thống
ID: UAT-WEB-032
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Kiểm tra chuyển đến màn hình import người dùng bằng role quản trị viên hệ thống
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Trên màn hình danh sách tenant, nhấn vào dòng tenant trong danh sách
② Nhấn "ユーザー一括アップロード"
期待される結果:
Màn hình "ユーザー一括アップロード" hiển thị.
種別: B


### UAT-WEB-033 Upload CSV hợp lệ - tạo thành công tất cả người dùng
ID: UAT-WEB-033
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload CSV hợp lệ - tạo thành công tất cả người dùng
前提条件:
Đã đăng nhập bằng quản trị viên hệ thống. Tenant đã được tạo. Có file CSV đúng template và dữ liệu hợp lệ.
実行手順:
① Mở màn hình "ユーザー一括アップロード"
② Nhấn "ファイルを選択" và chọn file CSV hợp lệ
③ Nhấn "一括アップロード"
期待される結果:
Thông báo thành công hiển thị và tất cả người dùng được tạo ở trạng thái "登録待ち". Thông tin người dùng chưa được đồng bộ với MVE.
種別: N


### UAT-WEB-034 Upload thất bại - file không phải CSV
ID: UAT-WEB-034
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - file không phải CSV
前提条件:
Đăng nhập bằng quản trị viên hệ thống.
実行手順:
① Chọn file .xlsx hoặc .txt thay vì .csv
② Nhấn "一括アップロード"
期待される結果:
Lỗi "アップロードされたファイルの形式が正しくありません。CSV形式のファイルを選択してください。" hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-035 Upload thất bại - header CSV khác template
ID: UAT-WEB-035
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - header CSV khác template
前提条件:
Có file CSV với header khác template chuẩn.
実行手順:
① Chọn file CSV đã thay đổi header
② Nhấn "一括アップロード"
期待される結果:
Lỗi header khác template hiển thị. Người dùng không được tạo và MVE API không được gọi.
種別: A


### UAT-WEB-036 Upload thất bại - file CSV rỗng
ID: UAT-WEB-036
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - file CSV rỗng
前提条件:
Có file CSV rỗng, không có header và không có dữ liệu.
実行手順:
① Upload file CSV rỗng
② Nhấn "一括アップロード"
期待される結果:
Lỗi "CSVファイルにデータが存在しません。内容をご確認ください。" hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-037 Upload thất bại - có dữ liệu lỗi (trùng email)
ID: UAT-WEB-037
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - có dữ liệu lỗi (trùng email)
前提条件:
File CSV hợp lệ nhưng có dòng chứa email đã tồn tại trong hệ thống.
実行手順:
① Upload file CSV có email trùng
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi lỗi trùng email.
種別: B


### UAT-WEB-038 Upload thất bại - trùng số SIP trong cùng tenant
ID: UAT-WEB-038
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - trùng số SIP trong cùng tenant
前提条件:
Trong file CSV có 2 dòng sử dụng cùng số máy nhánh SIP.
実行手順:
① Upload file CSV có số SIP trùng
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi lỗi trùng số SIP.
種別: B


### UAT-WEB-039 Upload lại sau khi sửa file lỗi
ID: UAT-WEB-039
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload lại sau khi sửa file lỗi
前提条件:
Đã chuẩn bị file CSV sau khi sửa nội dung lỗi.

実行手順:
① Mở file lỗi
② Sửa dữ liệu theo nội dung ghi chú lỗi
③ Xóa cột ghi chú lỗi
④ Upload lại
期待される結果:
Upload thành công và tất cả người dùng được tạo ở trạng thái "登録待ち".
種別: N


### UAT-WEB-040 Upload thất bại - file vượt quá 50MB
ID: UAT-WEB-040
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - file vượt quá 50MB
前提条件:
Có file CSV vượt quá 50MB.
実行手順:
① Chọn file lớn hơn 50MB
② Nhấn "一括アップロード"
期待される結果:
Lỗi dung lượng file hiển thị và file không được xử lý.
種別: B


### UAT-WEB-041 Upload thất bại - số SIP không hợp lệ
ID: UAT-WEB-041
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - số SIP không hợp lệ
前提条件:
Tenant ID = 111 nhưng số SIP nằm ngoài phạm vi 11000-11899.
実行手順:
① Upload file CSV có SIP ngoài phạm vi 11000-11899
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi số SIP không hợp lệ.
種別: B


### UAT-WEB-042 Upload thất bại - số SIP không hợp lệ
ID: UAT-WEB-042
画面/機能カテゴリ: Quản trị viên hệ thống
大項目: Import người dùng
中項目: Upload thất bại - số SIP không hợp lệ
前提条件:
Tenant ID = 500 nhưng số SIP nằm ngoài phạm vi 10000-99899.
実行手順:
① Upload file CSV có SIP ngoài phạm vi 10000-99899
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi số SIP không hợp lệ.
種別: B


### UAT-WEB-043 Quản trị viên tenant đăng nhập - nhận và nhập OTP thành công
ID: UAT-WEB-043
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Quản trị viên tenant đăng nhập - nhận và nhập OTP thành công
前提条件:
Tài khoản quản trị viên tenant hợp lệ.
実行手順:
① 第1回（DEV）: truy cập https://dev.apl.purattocall.com/admin/login
   第2回（PRD）: truy cập https://apl.purattocall.com/admin/login
② Nhập email và mật khẩu hợp lệ
③ Nhấn "ログイン"
④ Kiểm tra đã nhận mã OTP 6 chữ số qua email
⑤ Nhập OTP và nhấn "ログイン"
期待される結果:
Đăng nhập thành công. Chuyển đến màn hình danh sách người dùng. OTP có hiệu lực trong 3 phút.
種別: N


### UAT-WEB-044 OTP hết hạn - gửi lại OTP thành công
ID: UAT-WEB-044
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: OTP hết hạn - gửi lại OTP thành công
前提条件:
Đang hiển thị màn hình nhập OTP của quản trị viên tenant. OTP hết hạn sau 3 phút.
実行手順:
① Chờ quá 3 phút để OTP hết hạn
② Nhấn nút "再送信"
③ Nhập OTP mới nhận được
期待される結果:
Mã OTP mới được gửi và có thể đăng nhập bằng mã mới.
種別: B


### UAT-WEB-045 Đổi mật khẩu thành công
ID: UAT-WEB-045
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Đổi mật khẩu thành công
前提条件:
Đã đăng nhập bằng một role bất kỳ.
実行手順:
① Nhấn tên người dùng ở góc trên bên phải, sau đó nhấn "パスワード変更"
② Nhập mật khẩu hiện tại
③ Nhập mật khẩu mới (tối thiểu 8 ký tự, có chữ hoa, số và ký tự đặc biệt)
④ Nhập lại mật khẩu mới để xác nhận
⑤ Nhấn "確認"
期待される結果:
Mật khẩu được cập nhật thành công và có thể đăng nhập bằng mật khẩu mới.
種別: N


### UAT-WEB-046 Đổi mật khẩu thất bại - mật khẩu mới không đáp ứng điều kiện
ID: UAT-WEB-046
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Đổi mật khẩu thất bại - mật khẩu mới không đáp ứng điều kiện
前提条件:
Đã đăng nhập.
実行手順:
① Nhấn "パスワード変更"
② Nhập mật khẩu mới chỉ gồm chữ thường (không có chữ hoa, số và ký tự đặc biệt)
③ Nhấn "確認"
期待される結果:
Lỗi validation hiển thị và mật khẩu không được cập nhật.
種別: A


### UAT-WEB-047 Khôi phục mật khẩu bằng OTP qua email
ID: UAT-WEB-047
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Khôi phục mật khẩu bằng OTP qua email
前提条件:
Trong hệ thống có tài khoản.
実行手順:
① Nhấn "パスワードをお忘れの方"
② Nhập email đã đăng ký
③ Nhấn "送信"
④ Nhập mật khẩu mới
⑤ Nhấn "コード送信"
⑥ Nhập OTP nhận được qua email và nhấn "確認"
期待される結果:
Mật khẩu được đặt lại thành công và có thể đăng nhập bằng mật khẩu mới.
種別: N


### UAT-WEB-048 Đăng nhập thất bại 5 lần liên tiếp
ID: UAT-WEB-048
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Đăng nhập thất bại 5 lần liên tiếp
前提条件:
Trong hệ thống có tài khoản hợp lệ.
実行手順:
① Nhập email đúng và mật khẩu sai
② Thực hiện 5 lần liên tiếp
③ Nhấn "ログイン"
期待される結果:
Nếu nhập sai 5 lần liên tiếp, tài khoản bị khóa.
Có thể đặt lại mật khẩu bằng chức năng đặt lại mật khẩu.
種別: N


### UAT-WEB-049 Nhập sai mã OTP 5 lần liên tiếp
ID: UAT-WEB-049
画面/機能カテゴリ: Quản trị viên tenant
大項目: Đăng nhập và bảo mật
中項目: Nhập sai mã OTP 5 lần liên tiếp
前提条件:
Trong hệ thống có tài khoản hợp lệ.
実行手順:
① Nhập email và mật khẩu hợp lệ
② Nhấn nút "ログイン"
③ Nhập sai mã OTP 5 lần liên tiếp
期待される結果:
Hiển thị lỗi: "認証ワンタイムパスワードが正しくありません。"
Không thể đăng nhập vào hệ thống.
種別: N


### UAT-WEB-050 Hiển thị danh sách người dùng sau khi đăng nhập
ID: UAT-WEB-050
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Hiển thị danh sách người dùng sau khi đăng nhập
前提条件:
Quản trị viên tenant đăng nhập thành công.
実行手順:
① Sau khi đăng nhập thành công
期待される結果:
Tự động chuyển đến màn hình danh sách người dùng và danh sách người dùng của tenant hiện tại hiển thị đúng.
種別: N


### UAT-WEB-051 Tìm kiếm người dùng theo email
ID: UAT-WEB-051
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Tìm kiếm người dùng theo email
前提条件:
Trong tenant có ít nhất 2 người dùng.
実行手順:
① Nhập một phần email vào ô tìm kiếm
② Nhấn "検索"
期待される結果:
Chỉ người dùng có email khớp được hiển thị trong danh sách, các người dùng khác bị loại khỏi kết quả.
種別: N


### UAT-WEB-052 Tìm kiếm người dùng theo họ tên
ID: UAT-WEB-052
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Tìm kiếm người dùng theo họ tên
前提条件:
Có ít nhất 2 người dùng có tên khác nhau.
実行手順:
① Nhập họ tên vào ô họ tên
② Nhấn "検索"
期待される結果:
Kết quả lọc đúng theo tên được hiển thị, có phân biệt chữ hoa chữ thường.
種別: N


### UAT-WEB-053 Lọc người dùng theo trạng thái "利用中"
ID: UAT-WEB-053
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Lọc người dùng theo trạng thái "利用中"
前提条件:
Có người dùng ở nhiều trạng thái.
実行手順:
① Chọn trạng thái "利用中" trong dropdown
② Nhấn "検索"
期待される結果:
Chỉ người dùng ở trạng thái "利用中" được hiển thị.
種別: N


### UAT-WEB-054 Thêm người dùng mới thành công (MVE API thành công)
ID: UAT-WEB-054
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Thêm người dùng mới thành công (MVE API thành công)
前提条件:
MVE còn license khả dụng.
実行手順:
① Nhấn "ユーザー追加"
② Nhập email chưa đăng ký, họ, tên, họ kana, tên kana và số máy nhánh SIP hợp lệ
③ Nhấn "保存" -> "OK"
期待される結果:
Nếu MVE API trả về OK, người dùng được tạo ở trạng thái "登録済み".
Nếu API lỗi, người dùng được tạo ở trạng thái "登録待ち".
種別: N


### UAT-WEB-055 Thêm người dùng thất bại - email đã tồn tại trong hệ thống
ID: UAT-WEB-055
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Thêm người dùng thất bại - email đã tồn tại trong hệ thống
前提条件:
Email muốn sử dụng đã được người dùng khác sử dụng trong toàn hệ thống.
実行手順:
① Nhấn "ユーザー追加"
② Nhập email đã tồn tại
③ Nhấn "保存"
期待される結果:
Lỗi trùng email hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-056 Thêm người dùng thất bại - số SIP đã được sử dụng trong tenant
ID: UAT-WEB-056
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Thêm người dùng thất bại - số SIP đã được sử dụng trong tenant
前提条件:
Số SIP muốn nhập đã được người dùng khác trong cùng tenant sử dụng.
実行手順:
① Nhập số SIP đã tồn tại trong tenant
② Nhấn "保存"
期待される結果:
Lỗi trùng SIP trong tenant hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-057 Thêm người dùng thất bại - thiếu trường bắt buộc
ID: UAT-WEB-057
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Thêm người dùng thất bại - thiếu trường bắt buộc
前提条件:
Đang hiển thị màn hình "ユーザー追加".
実行手順:
① Để trống trường họ bắt buộc
② Nhấn "保存"
期待される結果:
Lỗi validation của trường họ hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-058 Kiểm tra phạm vi SIP theo loại tenant
ID: UAT-WEB-058
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Kiểm tra phạm vi SIP theo loại tenant
前提条件:
Tenant không sử dụng điện thoại cố định (mã 500-999).
実行手順:
① Nhập 99999 vào số SIP (ngoài phạm vi 10000-99899)
② Nhấn "保存"
期待される結果:
Lỗi ngoài phạm vi SIP hiển thị và người dùng không được tạo.
種別: A


### UAT-WEB-059 Kiểm tra chi tiết thông tin người dùng
ID: UAT-WEB-059
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Kiểm tra chi tiết thông tin người dùng
前提条件:
Trong tenant có ít nhất 1 người dùng.
実行手順:
① Nhấn vào dòng người dùng trong danh sách
期待される結果:
Email, họ tên, katakana, trạng thái, số SIP, địa chỉ, memo, ngày tạo và ngày cập nhật đều hiển thị.
種別: N


### UAT-WEB-060 Kiểm tra nút "編集" và "削除" với người dùng trạng thái "削除済み"
ID: UAT-WEB-060
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Kiểm tra nút "編集" và "削除" với người dùng trạng thái "削除済み"
前提条件:
Có người dùng ở trạng thái "削除済み".
実行手順:
① Nhấn người dùng mục tiêu ở trạng thái "削除済み"
② Kiểm tra các nút thao tác
期待される結果:
Nút "編集" và "削除" không hiển thị, chỉ có thể xem thông tin.
種別: B


### UAT-WEB-061 Chỉnh sửa thông tin người dùng - cập nhật họ tên
ID: UAT-WEB-061
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Chỉnh sửa thông tin người dùng - cập nhật họ tên
前提条件:
Trạng thái người dùng không phải "削除済み".
実行手順:
① Mở chi tiết người dùng và nhấn "編集"
② Chỉnh sửa họ, tên, họ kana, tên kana, địa chỉ và memo
③ Nhấn "保存"
期待される結果:
Họ, tên, họ kana, tên kana, địa chỉ và memo được cập nhật.
Không thể thay đổi email, trạng thái và số SIP.
種別: N


### UAT-WEB-062 Gửi email kích hoạt cho người dùng "登録済み"
ID: UAT-WEB-062
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Gửi email kích hoạt cho người dùng "登録済み"
前提条件:
Tồn tại người dùng ở trạng thái "登録済み".
実行手順:
① Chọn checkbox của người dùng "登録済み"
② Nhấn "ログイン情報通知"
③ Kiểm tra popup xác nhận thông thường
④ Nhấn nút "OK"
期待される結果:
Email kích hoạt được gửi thành công và trạng thái người dùng chuyển thành "アクティブ待ち".
種別: N


### UAT-WEB-063 Gửi lại email kích hoạt cho người dùng "アクティブ待ち"
ID: UAT-WEB-063
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Gửi lại email kích hoạt cho người dùng "アクティブ待ち"
前提条件:
Tồn tại người dùng ở trạng thái "アクティブ待ち" (đã gửi email 1 lần).
実行手順:
① Chọn checkbox của người dùng "アクティブ待ち"
② Nhấn "ログイン情報通知"
③ Nhấn nút "OK"
④ Tại popup "ログイン情報送信確認", nhấn nút "OK"
期待される結果:
Popup cảnh báo hiển thị (người dùng này đã được gửi email trước đó).
- Khi nhấn "OK", email kích hoạt được gửi cho toàn bộ người dùng đã chọn.
- Nếu nhấn "キャンセル" tại popup "キャンセル", email chỉ được gửi cho người dùng trạng thái "登録済み" và không gửi cho tài khoản "アクティブ待ち".
種別: N
備考:
実行結果: FAIL
ITEC_DENWA_APP-218


### UAT-WEB-064 Không thể gửi email kích hoạt cho người dùng ngoài trạng thái "登録済み" và "アクティブ待ち"
ID: UAT-WEB-064
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Không thể gửi email kích hoạt cho người dùng ngoài trạng thái "登録済み" và "アクティブ待ち"
前提条件:
Tồn tại người dùng ở trạng thái khác "登録済み" và "アクティブ待ち".
実行手順:
① Kiểm tra trạng thái hiển thị của checkbox
期待される結果:
Checkbox của người dùng ở trạng thái ngoài "登録済み" và "アクティブ待ち" bị vô hiệu hóa và không thể chọn.
種別: N


### UAT-WEB-065 Quay lại danh sách người dùng bằng nút "戻る"
ID: UAT-WEB-065
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Quay lại danh sách người dùng bằng nút "戻る"
前提条件:
Đang hiển thị màn hình chi tiết người dùng.
実行手順:
① Nhấn "戻る"
期待される結果:
Quay lại màn hình danh sách người dùng và điều kiện tìm kiếm ngay trước đó được giữ lại.
種別: B


### UAT-WEB-066 Tải xuống template CSV từ màn hình danh sách người dùng
ID: UAT-WEB-066
画面/機能カテゴリ: Quản trị viên tenant
大項目: Quản lý người dùng
中項目: Tải xuống template CSV từ màn hình danh sách người dùng
前提条件:
Đăng nhập bằng quản trị viên tenant.
実行手順:
① Nhấn "CSVテンプレートダウンロード"
期待される結果:
File người dùng.csv có header đúng định dạng template được tải xuống.
種別: N


### UAT-WEB-067 Upload CSV hợp lệ - tất cả người dùng được tạo
ID: UAT-WEB-067
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload CSV hợp lệ - tất cả người dùng được tạo
前提条件:
Đã đăng nhập bằng quản trị viên tenant và có file CSV hợp lệ theo template.
実行手順:
① Nhấn "ユーザー一括アップロード"
② Chọn file CSV hợp lệ
③ Nhấn "一括アップロード"
期待される結果:
Thông báo thành công hiển thị.
Nếu đăng ký vào MVE thành công, người dùng được tạo ở trạng thái "登録済み".
Nếu đăng ký vào MVE thất bại, người dùng được tạo ở trạng thái "登録待ち".
種別: N


### UAT-WEB-068 Upload thất bại - chưa chọn file
ID: UAT-WEB-068
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - chưa chọn file
前提条件:
Đang hiển thị màn hình import.
実行手順:
① Không chọn file
② Nhấn "一括アップロード"
期待される結果:
Lỗi "ファイルを1つも選択しない" hiển thị.
種別: A


### UAT-WEB-069 Upload thất bại - chỉ có header, không có dữ liệu
ID: UAT-WEB-069
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - chỉ có header, không có dữ liệu
前提条件:
File CSV chỉ có dòng header.
実行手順:
① Upload file CSV chỉ có header
② Nhấn "一括アップロード"
期待される結果:
Lỗi "CSVファイルがテンプレートと一致しません。" hiển thị.
種別: A


### UAT-WEB-070 Upload thất bại - chỉ có dữ liệu, không có header
ID: UAT-WEB-070
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - chỉ có dữ liệu, không có header
前提条件:
File CSV không có dòng header.
実行手順:
① Upload file CSV không có header
② Nhấn "一括アップロード"
期待される結果:
Lỗi "CSVファイルがテンプレートと一致しません。" hiển thị.
種別: A


### UAT-WEB-071 Upload thất bại - họ chứa ký tự đặc biệt không được phép
ID: UAT-WEB-071
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - họ chứa ký tự đặc biệt không được phép
前提条件:
File CSV có dòng họ = "Tanaka!@#".
実行手順:
① Upload file CSV có họ chứa ký tự đặc biệt
② Nhấn "一括アップロード"
期待される結果:
Lỗi "不正な文字が含まれています。もう一度確認してください。" hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi lỗi của mục họ.
種別: B


### UAT-WEB-072 Upload thất bại - họ kana chứa ký tự không phải katakana
ID: UAT-WEB-072
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - họ kana chứa ký tự không phải katakana
前提条件:
File CSV có dòng họ kana = "tanaka" (chữ thường, không phải katakana).
実行手順:
① Upload file CSV
② Nhấn "一括アップロード"
期待される結果:
Lỗi "全角カタカナで入力してください" hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi lỗi của mục họ kana.
種別: B


### UAT-WEB-073 Upload thất bại - số SIP không phải 4 chữ số (tenant điện thoại cố định)
ID: UAT-WEB-073
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - số SIP không phải 4 chữ số (tenant điện thoại cố định)
前提条件:
File CSV có dòng SIP = 99 (2 chữ số).
実行手順:
① Upload file CSV có SIP 2 chữ số
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi rằng SIP cần có 5 chữ số.
種別: B


### UAT-WEB-074 Upload thất bại - số SIP không hợp lệ
ID: UAT-WEB-074
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - số SIP không hợp lệ
前提条件:
Tenant ID = 111 nhưng số SIP nằm ngoài phạm vi 11000-11899.
実行手順:
① Upload file CSV có SIP ngoài phạm vi 11000-11899
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi số SIP không hợp lệ.
種別: B


### UAT-WEB-075 Upload thất bại - số SIP không hợp lệ
ID: UAT-WEB-075
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - số SIP không hợp lệ
前提条件:
Tenant ID = 500 nhưng số SIP nằm ngoài phạm vi 10000-99899.
実行手順:
① Upload file CSV có SIP ngoài phạm vi 10000-99899
② Nhấn "一括アップロード"
期待される結果:
Lỗi hiển thị và link tải file lỗi hiển thị.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi số SIP không hợp lệ.
種別: B


### UAT-WEB-076 Upload thất bại - email bị trùng trong cùng file CSV
ID: UAT-WEB-076
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Upload thất bại - email bị trùng trong cùng file CSV
前提条件:
Trong file CSV có 2 dòng sử dụng cùng email.
実行手順:
① Upload file có email trùng
② Nhấn "一括アップロード"
期待される結果:
Lỗi [{0} đã tồn tại. Vui lòng nhập giá trị khác.] hiển thị và link tải file lỗi hiển thị.
- {0}: giá trị người dùng nhập bị trùng với giá trị đã tồn tại.
Người dùng không được tạo.
Cột ghi chú lỗi trong file lỗi ghi lỗi trùng email.
種別: B


### UAT-WEB-077 Kiểm tra import bị vô hiệu hóa trong thời gian bảo trì
ID: UAT-WEB-077
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Kiểm tra import bị vô hiệu hóa trong thời gian bảo trì
前提条件:
Quản trị viên Okada Denki đã nhấn nút "メンテナンス開始" trên màn hình quản lý và đang thực hiện bảo trì.
実行手順:
① Quản trị viên tenant thực hiện upload file
期待される結果:
Chức năng import bị vô hiệu hóa và thông báo hệ thống đang bảo trì hiển thị.
種別: N


### UAT-WEB-078 Import hoạt động lại bình thường sau khi kết thúc bảo trì
ID: UAT-WEB-078
画面/機能カテゴリ: Quản trị viên tenant
大項目: Import hàng loạt người dùng
中項目: Import hoạt động lại bình thường sau khi kết thúc bảo trì
前提条件:
Quản trị viên Okada Denki đã nhấn nút "メンテナンス終了" trên màn hình quản lý và bảo trì đã kết thúc.
実行手順:
① Quản trị viên tenant thực hiện upload file
期待される結果:
Chức năng import hoạt động lại bình thường.
種別: N


### UAT-WEB-079 Xóa người dùng thành công
ID: UAT-WEB-079
画面/機能カテゴリ: Quản trị viên tenant
大項目: Xóa người dùng
中項目: Xóa người dùng thành công
前提条件:
Có người dùng ở trạng thái "利用中".
実行手順:
① Mở chi tiết người dùng
② Nhấn "削除"
③ Kiểm tra popup
期待される結果:
Trạng thái người dùng chuyển thành "削除済み" và người dùng không thể đăng nhập app. Dữ liệu vẫn còn trong database.
種別: N


### UAT-WEB-080 Kiểm tra người dùng "削除済み" vẫn tiếp tục hiển thị trong danh sách
ID: UAT-WEB-080
画面/機能カテゴリ: Quản trị viên tenant
大項目: Xóa người dùng
中項目: Kiểm tra người dùng "削除済み" vẫn tiếp tục hiển thị trong danh sách
前提条件:
Người dùng đã được xóa ở TA-D01.
実行手順:
① Hiển thị danh sách người dùng
② Tìm kiếm người dùng đã xóa
期待される結果:
Người dùng "削除済み" vẫn tiếp tục hiển thị trong danh sách; có thể xem thông tin nhưng không thể chỉnh sửa lại hoặc xóa lại.
種別: N


### UAT-WEB-081 Tài khoản SIP được xóa khỏi MVE sau khi Okada Denki thực hiện bảo trì
ID: UAT-WEB-081
画面/機能カテゴリ: Quản trị viên tenant
大項目: Xóa người dùng
中項目: Tài khoản SIP được xóa khỏi MVE sau khi Okada Denki thực hiện bảo trì
前提条件:
Trạng thái người dùng là "削除済み". Quản trị viên Okada Denki đã xuất CSV từ màn hình quản trị web, import vào MVE và kết thúc bảo trì.
実行手順:
① Xác nhận với Okada Denki rằng quy trình bảo trì đã hoàn tất
② Kiểm tra trạng thái SIP
期待される結果:
Tài khoản SIP bị xóa khỏi hệ thống MVE. Thông tin SIP trong database quản trị cũng bị xóa (trên màn hình danh sách người dùng, thông tin SIP không còn liên kết với người dùng đã xóa).
種別: B


### UAT-WEB-082 Quản trị viên Okada Denki đăng nhập thành công (IP whitelist)
ID: UAT-WEB-082
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Đăng nhập và bảo mật
中項目: Quản trị viên Okada Denki đăng nhập thành công (IP whitelist)
前提条件:
Tài khoản quản trị viên Okada Denki hợp lệ. IP nằm trong whitelist.
実行手順:
① Truy cập URL đăng nhập
② Nhập email và mật khẩu
③ Nhấn "ログイン"
期待される結果:
Chuyển trực tiếp đến màn hình quản lý Okada Denki và màn hình OTP không hiển thị.
種別: N


### UAT-WEB-083 Đăng nhập thất bại - IP ngoài whitelist (quản trị viên hệ thống/Okada Denki)
ID: UAT-WEB-083
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Đăng nhập và bảo mật
中項目: Đăng nhập thất bại - IP ngoài whitelist (quản trị viên hệ thống/Okada Denki)
前提条件:
IP hiện tại chưa được đăng ký trong whitelist.
実行手順:
① Nhập thông tin đăng nhập hợp lệ của quản trị viên hệ thống
② Nhấn "ログイン"
期待される結果:
Thông báo lỗi IP không được phép hiển thị và truy cập bị từ chối.
種別: N


### UAT-WEB-084 Tìm kiếm tenant theo tenant ID
ID: UAT-WEB-084
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Tìm kiếm tenant theo tenant ID
前提条件:
Trong danh sách có ít nhất 2 tenant.
実行手順:
① Nhập mã tenant vào ô tenant ID
② Nhấn "検索"
期待される結果:
Tenant khớp với ID được lọc đúng.
種別: N


### UAT-WEB-085 Tìm kiếm tenant theo tên nhóm IP
ID: UAT-WEB-085
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Tìm kiếm tenant theo tên nhóm IP
前提条件:
Tồn tại tenant đã được gán tên nhóm IP.
実行手順:
① Nhập một phần tên nhóm IP vào ô tên nhóm IP
② Nhấn "検索"
期待される結果:
Tenant có tên nhóm IP khớp được hiển thị đúng.
種別: N


### UAT-WEB-086 Kiểm tra tenant "登録待ち" được ưu tiên hiển thị đầu danh sách
ID: UAT-WEB-086
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Kiểm tra tenant "登録待ち" được ưu tiên hiển thị đầu danh sách
前提条件:
Tồn tại tenant ở nhiều trạng thái (登録待ち, 利用中).
実行手順:
① Kiểm tra danh sách tenant mà không áp dụng bộ lọc
期待される結果:
Tenant ở trạng thái "登録待ち" luôn hiển thị ở đầu danh sách.
種別: B


### UAT-WEB-087 Xác nhận hoàn tất tạo tên nhóm IP cho tenant "登録待ち"
ID: UAT-WEB-087
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Xác nhận hoàn tất tạo tên nhóm IP cho tenant "登録待ち"
前提条件:
Tenant ở trạng thái "登録待ち". Tên nhóm IP đã được thiết lập trên MVE server (ngoài màn hình quản trị web).
実行手順:
① Chọn checkbox của tenant "登録待ち"
② Nhấn "IPグループ名作成完了"
③ Kiểm tra popup
期待される結果:
- Trạng thái tenant chuyển thành "利用中".
- Hệ thống gọi MVE API và đăng ký người dùng ở trạng thái "登録待ち".
- Khi MVE API thành công, trạng thái người dùng chuyển từ "登録待ち" sang "登録済み".
- Khi API thất bại, trạng thái người dùng vẫn giữ là "登録待ち".
- Email thông báo kết quả được tự động gửi cho quản trị viên hệ thống.
種別: N


### UAT-WEB-088 Xác nhận IPGroup - nút không khả dụng với tenant "利用中"
ID: UAT-WEB-088
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Xác nhận IPGroup - nút không khả dụng với tenant "利用中"
前提条件:
Tenant ở trạng thái "利用中".
実行手順:
① Chọn checkbox của tenant "利用中"
② Kiểm tra nút "IPグループ名作成完了"
期待される結果:
Nút này không áp dụng cho tenant "利用中". Điều kiện chỉ áp dụng cho "登録待ち".
種別: B


### UAT-WEB-089 Xác nhận hàng loạt IPGroup của nhiều tenant
ID: UAT-WEB-089
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Quản lý tên nhóm IP của tenant
中項目: Xác nhận hàng loạt IPGroup của nhiều tenant
前提条件:
Tồn tại ít nhất 2 tenant ở trạng thái "登録待ち" và cả hai đã được thiết lập IPGroup trên MVE.
実行手順:
① Chọn checkbox của cả 2 tenant
② Nhấn "IPグループ名作成完了" và xác nhận
期待される結果:
Cả 2 tenant đều chuyển sang "利用中" và email thông báo được gửi cho quản trị viên hệ thống đối với từng tenant.
種別: B


### UAT-WEB-090 Hủy bảo trì khi nhấn "キャンセル" trên popup
ID: UAT-WEB-090
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Bảo trì
中項目: Hủy bảo trì khi nhấn "キャンセル" trên popup
前提条件:
Đã nhấn "メンテナンス開始" và popup đang hiển thị.
実行手順:
① Nhấn nút "メンテナンス開始"
② Kiểm tra popup "メンテナンスを開始します。よろしいですか？"
③ Nhấn "キャンセル"
期待される結果:
Popup đóng, bảo trì không bắt đầu và trạng thái hệ thống không thay đổi.
種別: B


### UAT-WEB-091 Bắt đầu bảo trì thành công
ID: UAT-WEB-091
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Bảo trì
中項目: Bắt đầu bảo trì thành công
前提条件:
Đã đăng nhập bằng quản trị viên Okada Denki. Dịch vụ đang hoạt động bình thường.
実行手順:
① Nhấn nút "メンテナンス開始"
② Kiểm tra popup "メンテナンスを開始します。よろしいですか？"
③ Nhấn "OK"
期待される結果:
Nút "メンテナンス開始" bị ẩn và nút "メンテナンス終了" hiển thị.
種別: N


### UAT-WEB-092 Cuộc gọi/tin nhắn trên app bị vô hiệu hóa trong thời gian bảo trì
ID: UAT-WEB-092
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Bảo trì
中項目: Cuộc gọi/tin nhắn trên app bị vô hiệu hóa trong thời gian bảo trì
前提条件:
Bảo trì đã bắt đầu (OD-M02).
実行手順:
① Người dùng thử thực hiện cuộc gọi trên app mobile
② Người dùng thử gửi tin nhắn
期待される結果:
Cuộc gọi âm thanh/video và tin nhắn bị vô hiệu hóa, thông báo bảo trì hiển thị trên app.
種別: B


### UAT-WEB-093 Kết thúc bảo trì thành công
ID: UAT-WEB-093
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Bảo trì
中項目: Kết thúc bảo trì thành công
前提条件:
Đang trong trạng thái bảo trì (OD-M02). Công việc trên MVE server đã hoàn tất.
実行手順:
① Nhấn nút "メンテナンス終了"
② Kiểm tra popup "メンテナンスを終了します。よろしいですか？"
③ Nhấn "OK"
期待される結果:
Nút "メンテナンス終了" bị ẩn, nút "メンテナンス開始" hiển thị lại và cuộc gọi/tin nhắn trên app được khôi phục.
種別: N


### UAT-WEB-094 Trạng thái bảo trì không bị hủy khi logout và login lại
ID: UAT-WEB-094
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Bảo trì
中項目: Trạng thái bảo trì không bị hủy khi logout và login lại
前提条件:
Đang trong trạng thái bảo trì.
実行手順:
① Logout khỏi màn hình quản trị web
② Login lại
③ Mở màn hình quản lý Okada Denki
期待される結果:
Trạng thái bảo trì được giữ nguyên và nút "メンテナンス終了" vẫn tiếp tục hiển thị.
種別: N


### UAT-WEB-095 Xuất CSV danh sách tài khoản SIP
ID: UAT-WEB-095
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Xuất tài khoản và đồng bộ MVE
中項目: Xuất CSV danh sách tài khoản SIP
前提条件:
Đã đăng nhập bằng quản trị viên Okada Denki và tồn tại tenant có người dùng hợp lệ.
実行手順:
① Nhấn "アカウント出力"
期待される結果:
File CSV được tải xuống tự động, gồm 4 cột: local user, username, password và tên nhóm IP.
種別: N


### UAT-WEB-096 Kiểm tra file CSV chỉ chứa người dùng ở trạng thái hợp lệ
ID: UAT-WEB-096
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Xuất tài khoản và đồng bộ MVE
中項目: Kiểm tra file CSV chỉ chứa người dùng ở trạng thái hợp lệ
前提条件:
Tenant có người dùng ở nhiều trạng thái: 登録待ち, 登録済み, アクティブ待ち, 利用中, 削除済み.
実行手順:
① Xuất CSV của tenant
② Mở file CSV để kiểm tra
期待される結果:
File CSV chứa người dùng ở trạng thái 登録待ち, 登録済み, アクティブ待ち, 利用中; người dùng "削除済み" không được đưa vào file xuất.
種別: N


### UAT-WEB-097 Kiểm tra định dạng dữ liệu trong file CSV
ID: UAT-WEB-097
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Xuất tài khoản và đồng bộ MVE
中項目: Kiểm tra định dạng dữ liệu trong file CSV
前提条件:
Đã xuất CSV (OD-E01).
実行手順:
① Mở file CSV
② Kiểm tra cột local user và cột tên nhóm IP
期待される結果:
Local user = tenant ID + số SIP máy nhánh (nối chuỗi, ví dụ: 50010001). Tên nhóm IP = "IPG_" + tên tenant.
種別: N


### UAT-WEB-098 Import file CSV vào MVE - người dùng "削除済み" bị xóa khỏi MVE
ID: UAT-WEB-098
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Xuất tài khoản và đồng bộ MVE
中項目: Import file CSV vào MVE - người dùng "削除済み" bị xóa khỏi MVE
前提条件:
Đã xuất CSV sau khi xóa người dùng. Đang bảo trì.
実行手順:
① Đăng nhập vào hệ thống MVE
② Import file CSV đã xuất từ màn hình quản trị web
③ Xác nhận import thành công
期待される結果:
Do người dùng "削除済み" không có trong CSV, người dùng này bị xóa khỏi MVE; các người dùng còn lại vẫn tồn tại trên MVE.
種別: B


### UAT-WEB-099 Chuỗi xử lý bảo trì khi xóa người dùng: xuất file, bảo trì, import MVE, kết thúc
ID: UAT-WEB-099
画面/機能カテゴリ: Quản trị viên Okada Denki
大項目: Xuất tài khoản và đồng bộ MVE
中項目: Chuỗi xử lý bảo trì khi xóa người dùng: xuất file, bảo trì, import MVE, kết thúc
前提条件:
Quản trị viên tenant đã xóa 1 người dùng (trạng thái "削除済み").
実行手順:
① Xuất CSV danh sách người dùng từ màn hình quản lý Okada Denki
② Nhấn "メンテナンス開始"
③ Đăng nhập vào hệ thống MVE và import file CSV đã xuất
④ Xác nhận import thành công trên MVE
⑤ Quay lại màn hình quản trị web và nhấn "メンテナンス終了"
期待される結果:
Do người dùng "削除済み" không có trong CSV, người dùng này bị xóa khỏi MVE và thông tin SIP không còn liên kết với người dùng trạng thái "削除済み".
Các người dùng còn lại tiếp tục tồn tại trên MVE.
種別: B


### UAT-WEB-100 Kiểm tra toàn bộ luồng từ tạo tenant, upload người dùng đến gửi email cho quản trị viên tenant
ID: UAT-WEB-100
画面/機能カテゴリ: Luồng onboarding
大項目: Onboarding
中項目: Kiểm tra toàn bộ luồng từ tạo tenant, upload người dùng đến gửi email cho quản trị viên tenant
前提条件:
Không có tenant test đang sử dụng và có file CSV người dùng hợp lệ.
実行手順:
① Đăng nhập bằng tài khoản role quản trị viên hệ thống
② Nhấn "テナント作成"
③ Nhập thông tin hợp lệ trên màn hình tạo tenant
④ Nhấn "保存" -> "OK"
⑤ Tại popup xác nhận upload người dùng, nhấn "はい"
⑥ Upload file CSV người dùng hợp lệ
⑦ Kiểm tra người dùng được tạo ở trạng thái "登録待ち"
⑧ Quản trị viên hệ thống gửi email đăng nhập cho quản trị viên tenant bằng nút "ログイン情報通知"
期待される結果:
Tenant được tạo thành công ở trạng thái "登録待ち".
Người dùng được tạo ở trạng thái "登録待ち" và quản trị viên tenant nhận được email đăng nhập.
種別: B


### UAT-WEB-101 Bỏ qua bước upload người dùng ngay sau khi tạo tenant
ID: UAT-WEB-101
画面/機能カテゴリ: Luồng onboarding
大項目: Onboarding
中項目: Bỏ qua bước upload người dùng ngay sau khi tạo tenant
前提条件:
Ngay sau khi tạo tenant mới, popup xác nhận upload đang hiển thị.
実行手順:
① Tại popup "ユーザー一括アップロード確認"
② Nhấn "いいえ"
期待される結果:
Popup đóng và quay lại màn hình danh sách tenant. Có thể upload người dùng sau.
種別: B


### UAT-WEB-102 Kiểm tra trạng thái người dùng chuyển thành "登録済み" sau khi Okada Denki xác nhận IPGroup
ID: UAT-WEB-102
画面/機能カテゴリ: Luồng onboarding
大項目: Onboarding
中項目: Kiểm tra trạng thái người dùng chuyển thành "登録済み" sau khi Okada Denki xác nhận IPGroup
前提条件:
Đã upload người dùng cho tenant "登録待ち". Okada Denki đã thiết lập IPGroup trên MVE.
実行手順:
① Đăng nhập bằng tài khoản role quản trị viên Okada Denki
② Okada Denki nhấn nút "IPグループ名作成完了" để xác nhận hoàn tất thiết lập tên nhóm IP
③ Quản trị viên hệ thống kiểm tra danh sách người dùng của tenant mục tiêu
期待される結果:
Trạng thái tenant chuyển từ "登録待ち" sang "利用中" và người dùng "登録待ち" tự động chuyển thành "登録済み" khi MVE API thành công.
種別: B


### UAT-WEB-103 Xác nhận kích hoạt tài khoản người dùng - trạng thái "利用中"
ID: UAT-WEB-103
画面/機能カテゴリ: Luồng onboarding
大項目: Onboarding
中項目: Xác nhận kích hoạt tài khoản người dùng - trạng thái "利用中"
前提条件:
Người dùng đã nhận email kích hoạt (trạng thái: "アクティブ待ち").
実行手順:
① Đăng nhập bằng tài khoản role quản trị viên tenant
② Quản trị viên tenant gửi email kích hoạt tài khoản cho người dùng bằng nút "ログイン情報通知"
③ Người dùng nhấn link kích hoạt trong email
④ Đăng nhập app mobile lần đầu
期待される結果:
Trạng thái người dùng tự động chuyển từ "アクティブ待ち" sang "利用中".
種別: B


### UAT-WEB-104 Kiểm tra quản trị viên tenant có thể đăng nhập sau khi nhận email
ID: UAT-WEB-104
画面/機能カテゴリ: Luồng onboarding
大項目: Onboarding
中項目: Kiểm tra quản trị viên tenant có thể đăng nhập sau khi nhận email
前提条件:
Quản trị viên tenant đã nhận email đăng nhập từ quản trị viên hệ thống.
実行手順:
① Quản trị viên tenant sử dụng thông tin trong email để đăng nhập màn hình quản trị web
期待される結果:
Đăng nhập thành công. Chuyển đến màn hình danh sách người dùng của tenant hiện tại.
種別: N


## 基本情報
| 項目 | 内容 |
| --- | --- |
| プロジェクト名 | ITEC Denwa |
| モジュール名 | VoIPWeb |
| テスト段階 | 受入テスト |
| 作成者 | VTI-SAM |
| 作成日 | 2026/06/20 |
| 環境 | DEV / PRD |
| 入力元 | UAT_VoIP電話ウェブ側テストケース.xlsx |
| 件数 | 104件 |

| 文書ID | TC-UAT-WEB-02 |
## 更新履歴
| バージョン | 依頼者 | 更新者 | 更新日時 | 変更理由 | シート名 | 更新内容 |
| --- | --- | --- | --- | --- | --- | --- |
| 1.0.2 | - | VTI-SAM | 2026/06/21 | 分類表記修正 | VoIPWeb受入テスト越語版 | 分類値を種別（N/A/B）へ統一 |
| 1.0.1 | - | VTI-SAM | 2026/06/21 | 環境表記修正 | VoIPWeb受入テスト越語版 | 第1回をDEV、第2回をPRDとして表記修正 |
| 1.0.0 | - | VTI-SAM | 2026/06/20 13:33 | 新規作成 | VoIPWeb受入テスト越語版 | UAT元テストケースから104件を正規化 |
