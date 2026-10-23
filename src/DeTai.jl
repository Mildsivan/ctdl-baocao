module DeTai

# DT028 — Tìm vị trí đầu, vị trí cuối và tần suất của x
# trên mảng đã tăng (không giảm) bằng hai tìm kiếm nhị phân.
#
# Quy ước: chỉ số 1-based như giáo trình và Julia. Giá trị 0 ở kết quả
# nghĩa là "không tìm thấy" (không có vị trí 0 trong mảng).

export kiem_tra_dau_vao, kiem_tra_x, vi_tri_dau, vi_tri_cuoi, tan_suat,
       lan_vet_tim_bien, quet_tuyen_tinh, vi_tri_chen, vi_tri_sau, dem_trong_doan

"""
    kiem_tra_dau_vao(a)

Kiểm tra hợp đồng dữ liệu vào của phiếu DT028:
  - `a` phải là `Vector{Int}`;
  - `0 ≤ n ≤ 10000` với `n = length(a)`;
  - `a` phải tăng không giảm: `a[1] ≤ a[2] ≤ … ≤ a[n]`.

Trả `true` khi hợp lệ; ném `ArgumentError` kèm lý do khi vi phạm.
Mảng rỗng `Int[]` là hợp lệ (n = 0); khóa trùng là hợp lệ.
"""
function kiem_tra_dau_vao(a)
    a isa Vector{Int} || throw(ArgumentError("du lieu vao phai la Vector{Int}"))
    n = length(a)
    n <= 10_000 || throw(ArgumentError("n = $n vuot gioi han 10000"))
    for i in 2:n
        if a[i - 1] > a[i]
            throw(ArgumentError("mang phai tang khong giam: a[$(i - 1)] = $(a[i - 1]) > a[$i] = $(a[i])"))
        end
    end
    return true
end

"""
    kiem_tra_x(x)

Kiểm tra khóa cần tìm là số nguyên. Không giới hạn miền giá trị của `x`
theo phiếu; mọi số nguyên đều được chấp nhận.
"""
function kiem_tra_x(x)
    x isa Integer || throw(ArgumentError("x phai la so nguyen, nhan duoc $(typeof(x))"))
    return true
end

"""
    vi_tri_dau(a, x; dem=Ref(0))

Tìm vị trí xuất hiện **đầu tiên** của `x` trong mảng tăng `a`.
Trả chỉ số 1-based, hoặc `0` nếu `x` không có trong mảng.

Khi gặp `a[mid] == x`, lưu `mid` vào `kq` rồi tiếp tục tìm sang **trái**
(`hi = mid - 1`) để tìm vị trí nhỏ hơn. `dem[]` đếm số lần xét `mid`.
"""
function _vi_tri_dau(a, x, dem::Base.RefValue{Int})
    lo, hi, kq = 1, length(a), 0
    while lo <= hi
        mid = lo + (hi - lo) ÷ 2
        dem[] += 1
        if a[mid] < x
            lo = mid + 1
        elseif a[mid] > x
            hi = mid - 1
        else
            kq = mid
            hi = mid - 1          # còn có thể có x bên trái
        end
    end
    return kq
end

function vi_tri_dau(a, x; dem::Base.RefValue{Int}=Ref(0))
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    return _vi_tri_dau(a, x, dem)
end

"""
    vi_tri_cuoi(a, x; dem=Ref(0))

Tìm vị trí xuất hiện **cuối cùng** của `x` trong mảng tăng `a`.
Trả chỉ số 1-based, hoặc `0` nếu `x` không có trong mảng.

Khi gặp `a[mid] == x`, lưu `mid` vào `kq` rồi tiếp tục tìm sang **phải**
(`lo = mid + 1`) để tìm vị trí lớn hơn. `dem[]` đếm số lần xét `mid`.
"""
function _vi_tri_cuoi(a, x, dem::Base.RefValue{Int})
    lo, hi, kq = 1, length(a), 0
    while lo <= hi
        mid = lo + (hi - lo) ÷ 2
        dem[] += 1
        if a[mid] < x
            lo = mid + 1
        elseif a[mid] > x
            hi = mid - 1
        else
            kq = mid
            lo = mid + 1          # còn có thể có x bên phải
        end
    end
    return kq
end

function vi_tri_cuoi(a, x; dem::Base.RefValue{Int}=Ref(0))
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    return _vi_tri_cuoi(a, x, dem)
end

# Lõi ghép hai biên, giả định a và x đã được kiểm tra hợp lệ.
function _tan_suat(a, x)
    dem_dau = Ref(0)
    dem_cuoi = Ref(0)
    dau = _vi_tri_dau(a, x, dem_dau)
    cuoi = _vi_tri_cuoi(a, x, dem_cuoi)
    count = dau == 0 ? 0 : cuoi - dau + 1
    @assert (dau == 0) == (cuoi == 0) "hai bien khong nhat quan"
    @assert count == 0 || cuoi >= dau
    return (; dau, cuoi, count, xet_dau=dem_dau[], xet_cuoi=dem_cuoi[])
end

"""
    tan_suat(a, x; dem=Ref(0))

Ghép hai tìm kiếm biên: trả `(dau, cuoi, count, xet_dau, xet_cuoi)`.
Nếu `x` vắng mặt thì `dau = cuoi = count = 0`; nếu có thì
`count = cuoi - dau + 1`. Hai bộ đếm `xet_dau`, `xet_cuoi` là số lần
xét `mid` của từng lần tìm kiếm (dùng cho phần đếm phép toán).
Dữ liệu vào được kiểm tra đúng một lần trước khi chạy hai lần tìm.
"""
function tan_suat(a, x; dem::Base.RefValue{Int}=Ref(0))
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    kq = _tan_suat(a, x)
    dem[] += kq.xet_dau + kq.xet_cuoi
    return kq
end

"""
    quet_tuyen_tinh(a, x)

Bản tham chiếu O(n) để đối chiếu: quét trái sang phải ghi vị trí đầu,
quét phải sang trái ghi vị trí cuối. Trả `(dau, cuoi, count, so_sanh)`.
Không dùng hàm này trong lõi tìm kiếm nhị phân; chỉ dùng khi kiểm thử.
"""
function quet_tuyen_tinh(a, x)
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    n = length(a)
    dau = 0
    so_sanh = 0
    for i in 1:n
        so_sanh += 1
        if a[i] == x
            dau = i
            break
        elseif a[i] > x
            break
        end
    end
    cuoi = 0
    if dau != 0
        for i in n:-1:1
            so_sanh += 1
            if a[i] == x
                cuoi = i
                break
            end
        end
    end
    count = dau == 0 ? 0 : cuoi - dau + 1
    return (; dau, cuoi, count, so_sanh)
end

"""
    vi_tri_chen(a, x)

Vị trí chèn (lower bound): chỉ số đầu tiên có `a[i] ≥ x`, hoặc `n + 1`
nếu mọi phần tử đều nhỏ hơn `x`. Dùng để đếm phần tử trong đoạn giá trị.
"""
function vi_tri_chen(a, x)
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    lo, hi = 1, length(a)
    while lo <= hi
        mid = lo + (hi - lo) ÷ 2
        if a[mid] < x
            lo = mid + 1
        else
            hi = mid - 1
        end
    end
    return lo
end

"""
    vi_tri_sau(a, x)

Chỉ số đầu tiên có `a[i] > x` (upper bound), hoặc `n + 1` nếu không có.
"""
function vi_tri_sau(a, x)
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    lo, hi = 1, length(a)
    while lo <= hi
        mid = lo + (hi - lo) ÷ 2
        if a[mid] <= x
            lo = mid + 1
        else
            hi = mid - 1
        end
    end
    return lo
end

"""
    dem_trong_doan(a, L, U)

Yêu cầu tùy chọn của phiếu: dùng hai biên để đếm số phần tử có giá trị
trong đoạn `[L, U]`. Trả 0 khi `L > U`; không duyệt từng phần tử.
Công thức: `vi_tri_sau(a, U) - vi_tri_chen(a, L)`.
"""
function dem_trong_doan(a, L, U)
    kiem_tra_dau_vao(a)
    kiem_tra_x(L)
    kiem_tra_x(U)
    L > U && return 0
    return max(0, vi_tri_sau(a, U) - vi_tri_chen(a, L))
end

"""
    lan_vet_tim_bien(a, x; io=stdout)

In lần vết hai quá trình tìm biên: mỗi dòng ghi `lo`, `hi`, `mid`,
`a[mid]`, phép so sánh và nhánh quyết định. Trả về cùng kết quả với
`tan_suat`. Dùng cho bảng truy vết T01 của báo cáo.
"""
function lan_vet_tim_bien(a, x; io=stdout)
    kiem_tra_dau_vao(a)
    kiem_tra_x(x)
    println(io, "Lan vet hai tim kiem nhi phan, n = ", length(a), ", x = ", x)
    for (ten, tim_dau) in (("TIM DAU ", true), ("TIM CUOI", false))
        println(io, "-- ", ten, " --")
        lo, hi, kq, buoc = 1, length(a), 0, 0
        while lo <= hi
            mid = lo + (hi - lo) ÷ 2
            buoc += 1
            if a[mid] < x
                println(io, "  buoc $buoc: lo=$lo hi=$hi mid=$mid a[mid]=$(a[mid]) < x  -> lo = mid + 1 = $(mid + 1)")
                lo = mid + 1
            elseif a[mid] > x
                println(io, "  buoc $buoc: lo=$lo hi=$hi mid=$mid a[mid]=$(a[mid]) > x  -> hi = mid - 1 = $(mid - 1)")
                hi = mid - 1
            else
                kq = mid
                if tim_dau
                    println(io, "  buoc $buoc: lo=$lo hi=$hi mid=$mid a[mid]=$(a[mid]) = x  -> nhan $mid, hi = mid - 1 = $(mid - 1)")
                    hi = mid - 1
                else
                    println(io, "  buoc $buoc: lo=$lo hi=$hi mid=$mid a[mid]=$(a[mid]) = x  -> nhan $mid, lo = mid + 1 = $(mid + 1)")
                    lo = mid + 1
                end
            end
        end
        println(io, "  ket qua ", ten, " = ", kq, " sau ", buoc, " lan xet mid")
    end
    return _tan_suat(a, x)
end

end # module DeTai
