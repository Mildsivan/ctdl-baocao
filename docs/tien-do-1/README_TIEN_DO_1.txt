BÁO CÁO TIẾN ĐỘ 1 — PHAN ĐỨC HUY — N24DCDT034 — DT028
Học phần INT13185 — Nhóm 03 — GV: Hồ Nhựt Minh

GỒM
===
1. BAO_CAO_TIEN_DO_1_PhanDucHuy_DT028.docx
2. BAO_CAO_TIEN_DO_1_PhanDucHuy_DT028.pdf
3. MaNguon_TienDo1.zip — mã nguồn tại commit C:
   src/DeTai.jl, demo.jl, test/runtests.jl, scripts/, README.md, Run_all.ps1

NỘI DUNG ĐÃ LÀM
===============
- Đọc phiếu DT028, xác định input/output, 5 ca kiểm.
- Cài hai tìm kiếm nhị phân tìm biên, ghép tần suất, kiểm tra dữ liệu vào.
- Bộ test 12 ca chức năng + LOI01; 18.624/18.624 phép kiểm đạt.
- Bảng truy vết T01, khảo sát n = 5, 50, 500, 5000.
- Ảnh minh chứng A01, A02, A09.

CÁCH CHẠY
=========
Giải nén MaNguon_TienDo1.zip, mở PowerShell tại thư mục vừa giải nén:

    powershell -ExecutionPolicy Bypass -File .\Run_all.ps1

Yêu cầu: Julia 1.13.1, không cần thư viện ngoài.

CÒN LẠI CHO ĐỢT 2
=================
- Push commit C lên GitHub.
- Chụp A11, clone C và chụp A10.
- Bổ sung A10/A11 vào báo cáo, commit S, lấy SHA S.
- Clone S chạy lại, cập nhật TXT và xuất PDF cuối.

MÃ NGUỒN GITHUB
================
https://github.com/Mildsivan/ctdl-baocao
