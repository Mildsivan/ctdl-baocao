# DT028 — Tìm vị trí đầu, cuối và tần suất của x

Báo cáo đồ án học phần **INT13185 — Cấu trúc dữ liệu và giải thuật, Nhóm 03**.

- **Họ tên, MSSV, lớp:** Phan Đức Huy — N24DCDT034 — D24CQDT01-N.
- **Mã đề / tên đề:** DT028 — Tìm vị trí đầu, cuối và tần suất của x.
- **Giáo trình:** *Cấu trúc dữ liệu và Giải thuật* INT1306, Chương 2, Mục 2.6.2;
  mục 2.8 bài 28; trang in 50–52, 62; trang PDF 62–64, 74.
- **Ngôn ngữ:** Julia (được kiểm với **Julia 1.13.1**, chỉ dùng thư viện chuẩn).

## Bắt đầu

Từ thư mục mã, chạy trong PowerShell:

```powershell
.\Run_all.ps1
```

Nếu `julia.exe` chưa có trên PATH, truyền đường dẫn:

```powershell
.\Run_all.ps1 -Julia 'DUONG_DAN_DEN_JULIA_EXE'
```

`Run_all.ps1` chạy lần lượt các lệnh dưới và dừng ngay khi một lệnh trả mã lỗi.
Không cần CSV, Excel, mạng hay tệp dữ liệu ngoài.

```powershell
julia --startup-file=no demo.jl            # chạy toàn bộ 8 ca + so sánh
julia --startup-file=no demo.jl --ca=1     # chạy riêng ca 1..8
julia --startup-file=no demo.jl --so-sanh  # chỉ in so sánh nhị phân vs tuyến tính
julia --startup-file=no demo.jl --nhap     # nhập mảng và x từ bàn phím
julia --startup-file=no test/runtests.jl
julia --startup-file=no scripts/test_catalog.jl
julia --startup-file=no scripts/trace_and_scales.jl
```

## Hợp đồng bài toán

- **Đầu vào:** `a::Vector{Int}` tăng không giảm, `0 ≤ n ≤ 10000`; `x` là số nguyên,
  không giới hạn miền. Khóa trùng hợp lệ; mảng rỗng hợp lệ. Nhập bàn phím,
  khai báo trực tiếp hoặc truyền tham số.
- **Đầu ra:** `first`, `last` (chỉ số 1-based) và `count`. Nếu `x` vắng mặt:
  `first = last = 0`, `count = 0`. Nếu có: `count = last - first + 1`.
- Hai lần tìm kiếm nhị phân độc lập: bản tìm đầu thu hẹp sang trái khi gặp `x`,
  bản tìm cuối thu hẹp sang phải. Không dùng vị trí chèn thay cho lần xuất hiện.
- Thời gian `O(log n)`, bộ nhớ phụ `O(1)`; quét tuyến tính `O(n)` chỉ dùng để đối chiếu.

## Các phần đã giải

| Tệp | Vai trò |
|---|---|
| `src/DeTai.jl` | `kiem_tra_dau_vao`, `vi_tri_dau`, `vi_tri_cuoi`, `tan_suat`, `lan_vet_tim_bien`, `quet_tuyen_tinh`, `vi_tri_chen`, `vi_tri_sau`, `dem_trong_doan` |
| `demo.jl` | 8 ca minh hoạ A01–A08 + so sánh nhị phân/tuyến tính + nhập bàn phím |
| `test/runtests.jl` | 12 ca chức năng/biên + đối chiếu tuyến tính/bất biến + kiểm tra dữ liệu vào |
| `scripts/test_catalog.jl` | In input/expected/actual/PASS của 12 ca chức năng (LOI01 kiểm riêng trong test) |
| `scripts/trace_and_scales.jl` | Truy vết T01 và khảo sát n = 5, 50, 500, 5000 |
| `Run_all.ps1` | Chạy toàn bộ quy trình bằng một lệnh |

## Lập luận và kiểm chứng

Bản tìm đầu giữ bất biến: mọi vị trí `< lo` đều nhỏ hơn `x`; mọi vị trí `> hi`
đều lớn hơn hoặc bằng `x`; `kq` là ứng viên tốt nhất đã thấy. Khi `a[mid] == x`,
`mid` là ứng viên và mọi vị trí bên phải không thể là **đầu tiên**, nên
`hi = mid - 1`. Bản tìm cuối đối xứng với `lo = mid + 1`. Mỗi vòng loại ít nhất
một nửa miền nên dừng sau `O(log n)` bước. Khi `x` vắng mặt, cả hai bản trả 0;
khi có, `last - first + 1` đúng bằng số lần xuất hiện vì mảng đã tăng.

## Mã nguồn và chạy lại

Mã nguồn: https://github.com/Mildsivan/ctdl-baocao

Clone và chạy lại:

```powershell
git clone https://github.com/Mildsivan/ctdl-baocao.git
cd ctdl-baocao
.\Run_all.ps1
```

## Quy ước nộp Classroom

Nộp đủ bốn tệp đúng tên `N24DCDT034_DT028_PhanDucHuy_*` (Word, PDF, ZIP mã, TXT).
Repo riêng tư phải cấp quyền cho giảng viên trước hạn nộp. Không đưa token/mật
khẩu vào repo hoặc báo cáo.

