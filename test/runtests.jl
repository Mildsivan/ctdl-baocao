# test/runtests.jl — Bộ kiểm thử DT028 (Tìm vị trí đầu, cuối và tần suất của x).
# Lệnh: julia --startup-file=no test/runtests.jl

using Test
using Random
include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

# Kiểm tra bất biến chung của một lần tìm:
# - first = 0 khi và chỉ khi last = 0;
# - nếu có thì 1 <= first <= last <= n và count = last - first + 1;
# - kết quả trùng với quét tuyến tính độc lập;
# - số lần xét mid không vượt quá 2*ceil(log2(n+1)) cho cả hai lần tìm.
function kiem_bat_bien(a, x)
    kq = tan_suat(a, x)
    lt = quet_tuyen_tinh(a, x)
    n = length(a)
    @test (kq.dau == 0) == (kq.cuoi == 0)
    @test (kq.dau, kq.cuoi, kq.count) == (lt.dau, lt.cuoi, lt.count)
    if kq.dau != 0
        @test 1 <= kq.dau <= kq.cuoi <= n
        @test kq.count == kq.cuoi - kq.dau + 1
        @test a[kq.dau] == x && a[kq.cuoi] == x
    else
        @test kq.count == 0
    end
    if n > 0
        @test kq.xet_dau + kq.xet_cuoi <= 2 * ceil(Int, log2(n + 1))
    end
    return kq
end

@testset "DT028 - 12 ca chuc nang va bien" begin
    # VD01 — Ví dụ 1 phiếu.
    kq = tan_suat([1, 2, 2, 2, 4], 2)
    @test (kq.dau, kq.cuoi, kq.count) == (2, 4, 3)
    @test kq.xet_dau + kq.xet_cuoi == 6

    # VD02 — Ví dụ 2 phiếu: x vắng mặt, không gán vị trí chèn thành lần xuất hiện.
    kq = tan_suat([1, 2, 2, 2, 4], 3)
    @test (kq.dau, kq.cuoi, kq.count) == (0, 0, 0)
    @test kq.xet_dau == 3 && kq.xet_cuoi == 3

    # TK01 — Tự thiết kế 1: x ở đầu mảng, ba lần xuất hiện.
    kq = tan_suat([1, 1, 1, 5, 9], 1)
    @test (kq.dau, kq.cuoi, kq.count) == (1, 3, 3)

    # TK02 — Tự thiết kế 2: x ở cuối mảng, hai lần xuất hiện.
    kq = tan_suat([0, 3, 7, 7], 7)
    @test (kq.dau, kq.cuoi, kq.count) == (3, 4, 2)

    # BIEN01 — Ca phiếu 4: [1, 2], x = 1.
    kq = tan_suat([1, 2], 1)
    @test (kq.dau, kq.cuoi, kq.count) == (1, 1, 1)
    @test kq.xet_dau + kq.xet_cuoi == 3

    # BIEN02 — Ca phiếu 5: mảng rỗng.
    kq = tan_suat(Int[], 5)
    @test (kq.dau, kq.cuoi, kq.count) == (0, 0, 0)
    @test kq.xet_dau == 0 && kq.xet_cuoi == 0

    # BIEN03 — Ca phiếu 3: [5, 5, 5], x = 5.
    kq = tan_suat([5, 5, 5], 5)
    @test (kq.dau, kq.cuoi, kq.count) == (1, 3, 3)

    # KT09 — Một phần tử.
    kq = tan_suat([5], 5)
    @test (kq.dau, kq.cuoi, kq.count) == (1, 1, 1)
    @test kq.xet_dau + kq.xet_cuoi == 2

    # KT10 — x nhỏ hơn mọi phần tử.
    kq = tan_suat([2, 4, 6], 1)
    @test (kq.dau, kq.cuoi, kq.count) == (0, 0, 0)

    # KT11 — x lớn hơn mọi phần tử.
    kq = tan_suat([2, 4, 6], 9)
    @test (kq.dau, kq.cuoi, kq.count) == (0, 0, 0)

    # KT12 — Mảng dài hơn, khóa trùng ở giữa.
    kq = tan_suat([1, 3, 3, 3, 3, 5, 7, 7], 3)
    @test (kq.dau, kq.cuoi, kq.count) == (2, 5, 4)

    # KT13 — Số âm, x ở đầu.
    kq = tan_suat([-5, -5, -2, 0], -5)
    @test (kq.dau, kq.cuoi, kq.count) == (1, 2, 2)

    # Yêu cầu tùy chọn: đếm phần tử trong đoạn [L, U] bằng hai biên.
    @test dem_trong_doan([1, 3, 3, 3, 3, 5, 7, 7], 3, 5) == 5
    @test dem_trong_doan([1, 3, 3, 3, 3, 5, 7, 7], 4, 6) == 1
    @test dem_trong_doan([1, 3, 3, 3, 3, 5, 7, 7], 6, 6) == 0
    @test dem_trong_doan([1, 3, 3, 3, 3, 5, 7, 7], 8, 2) == 0
end

@testset "DT028 - doi chieu tuyen tinh va bat bien" begin
    Random.seed!(2026)
    for n in 0:40
        for _ in 1:20
            a = sort(rand(-50:50, n))
            # Chọn x khi có trong mảng, khi nhỏ hơn, khi lớn hơn và khi ở giữa hai giá trị.
            xs = Integer[]
            isempty(a) || push!(xs, a[rand(1:n)])
            push!(xs, -51, 51)
            if n >= 2
                i = rand(1:(n - 1))
                push!(xs, a[i])                      # giá trị có thể trùng
                a[i] < a[i + 1] && push!(xs, a[i] + 1)  # giá trị vắng mặt
            end
            for x in unique(xs)
                kiem_bat_bien(a, x)
            end
        end
    end

    # Hai hàm biên phải khớp nhau và khớp quét tuyến tính trên mọi x đã thử.
    a = [1, 1, 2, 2, 2, 7, 9, 9]
    for x in -1:10
        d = vi_tri_dau(a, x)
        c = vi_tri_cuoi(a, x)
        lt = quet_tuyen_tinh(a, x)
        @test (d, c) == (lt.dau, lt.cuoi)
    end

    # vi_tri_chen / vi_tri_sau khớp định nghĩa lower bound / upper bound.
    for x in -1:10
        chen_lt = findfirst(v -> v >= x, a)
        sau_lt = findfirst(v -> v > x, a)
        mong_doi_chen = chen_lt === nothing ? length(a) + 1 : chen_lt
        mong_doi_sau = sau_lt === nothing ? length(a) + 1 : sau_lt
        @test vi_tri_chen(a, x) == mong_doi_chen
        @test vi_tri_sau(a, x) == mong_doi_sau
    end
end

@testset "DT028 - kiem tra du lieu vao" begin
    @test kiem_tra_dau_vao(Int[]) == true
    @test kiem_tra_dau_vao([1, 1, 2, 2, 2, 4]) == true
    @test kiem_tra_dau_vao([-10^9, 0, 10^9]) == true
    @test_throws ArgumentError kiem_tra_dau_vao(fill(0, 10_001))   # LOI01: n > 10000
    @test_throws ArgumentError kiem_tra_dau_vao([3, 1, 2])          # LOI02: khong tang
    @test_throws ArgumentError kiem_tra_dau_vao([1, 2, 2, 1])       # LOI02b: giam o cuoi
    @test_throws ArgumentError kiem_tra_dau_vao([1.5, 2.0])         # LOI03: khong phai Vector{Int}
    @test_throws ArgumentError tan_suat([1, 2, 3], 2.5)             # LOI04: x khong nguyen
    @test_throws ArgumentError vi_tri_dau([2, 1], 1)                # khong hop le
end

println("DA QUA BO KIEM THU DT028: 12 ca chuc nang, doi chieu tuyen tinh/bat bien va kiem tra du lieu vao.")
