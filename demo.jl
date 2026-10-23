# demo.jl — Chạy minh hoạ cho DT028 (Tìm vị trí đầu, cuối và tần suất của x).
# Lệnh: julia --startup-file=no demo.jl [--ca=N | --nhap | --so-sanh]

include(joinpath(@__DIR__, "src", "DeTai.jl"))
using .DeTai

# (mảng, x, nhãn, expected (dau, cuoi, count))
const CAC_CA = [
    ([1, 2, 2, 2, 4], 2, "A01 - Vi du 1 phieu: [1,2,2,2,4], x = 2", (2, 4, 3)),
    ([1, 2, 2, 2, 4], 3, "A02 - Vi du 2 phieu: [1,2,2,2,4], x = 3", (0, 0, 0)),
    ([1, 1, 1, 5, 9], 1, "A03 - Tu thiet ke 1: x nam o dau mang", (1, 3, 3)),
    ([0, 3, 7, 7], 7, "A04 - Tu thiet ke 2: x nam o cuoi mang", (3, 4, 2)),
    ([1, 2], 1, "A05 - Ca phieu 4: [1,2], x = 1", (1, 1, 1)),
    (Int[], 5, "A06 - Ca phieu 5: mang rong", (0, 0, 0)),
    ([5, 5, 5], 5, "A07 - Ca phieu 3: [5,5,5], x = 5", (1, 3, 3)),
]

function chay_ca(a, x, nhan, expected)
    println("="^70)
    println("CA: ", nhan)
    println("Input  : a = ", a, "   x = ", x)
    kiem_tra_dau_vao(a)
    kq = tan_suat(a, x)
    println("Ket qua: first = ", kq.dau, ", last = ", kq.cuoi, ", count = ", kq.count)
    println("So lan xet mid: dau = ", kq.xet_dau, ", cuoi = ", kq.xet_cuoi,
            " (tong = ", kq.xet_dau + kq.xet_cuoi, ")")
    if kq.dau == 0
        println("Kiem tra: x khong xuat hien -> first = last = count = 0")
    else
        println("Kiem tra: count = last - first + 1 = ", kq.cuoi, " - ", kq.dau, " + 1 = ", kq.count)
    end
    lt = quet_tuyen_tinh(a, x)
    println("Tuyen tinh: first = ", lt.dau, ", last = ", lt.cuoi,
            ", count = ", lt.count, " (so sanh = ", lt.so_sanh, ")")
    @assert (kq.dau, kq.cuoi, kq.count) == expected "SAI KY VONG: $((kq.dau, kq.cuoi, kq.count)) vs $expected"
    @assert (lt.dau, lt.cuoi, lt.count) == expected "SAI DOI CHIEU TUYEN TINH"
    println("KET LUAN: PASS")
    println()
end

function chay_ca_loi()
    println("="^70)
    println("CA: A08 - Input khong hop le (validator tu choi)")
    for (nhan, du_lieu) in [
            ("mang khong tang [3, 1, 2]", [3, 1, 2]),
            ("n = 10001 vuot gioi han", fill(0, 10_001)),
            ("x = 2.5 khong phai so nguyen", nothing),
        ]
        print("  ", nhan, ": ")
        try
            du_lieu === nothing ? tan_suat([1, 2, 3], 2.5) : kiem_tra_dau_vao(du_lieu)
            println("KHONG PHAT HIEN (LOI)")
        catch e
            println(typeof(e), " - ", e.msg)
        end
    end
    println()
end

function so_sanh_nhi_phan_va_tuyen_tinh()
    println("="^70)
    println("SO SANH: hai tim kiem nhi phan voi quet tuyen tinh")
    for (a, x) in [([1, 2, 2, 2, 4], 2), ([1, 1, 1, 5, 9], 1),
                   ([0, 3, 7, 7], 7), ([2, 4, 6, 8, 10, 12, 14, 16], 9)]
        kq = tan_suat(a, x)
        lt = quet_tuyen_tinh(a, x)
        println("a = ", a, "  x = ", x)
        println("  Nhi phan  : first=", kq.dau, " last=", kq.cuoi, " count=", kq.count,
                " | xet mid = ", kq.xet_dau + kq.xet_cuoi)
        println("  Tuyen tinh: first=", lt.dau, " last=", lt.cuoi, " count=", lt.count,
                " | so sanh = ", lt.so_sanh)
    end
    println()
end

function nhap_ban_phim()
    println("Nhap n (so phan tu, 0 <= n <= 10000):")
    n = parse(Int, readline())
    println("Nhap $n so nguyen tang khong giam, moi so mot dong:")
    a = Int[parse(Int, readline()) for _ in 1:n]
    println("Nhap x:")
    x = parse(Int, readline())
    kiem_tra_dau_vao(a)
    kq = tan_suat(a, x)
    println("Ket qua: first = ", kq.dau, ", last = ", kq.cuoi, ", count = ", kq.count)
    println("So lan xet mid: ", kq.xet_dau, " + ", kq.xet_cuoi, " = ", kq.xet_dau + kq.xet_cuoi)
end

function chay_tat_ca()
    for (a, x, nhan, expected) in CAC_CA
        chay_ca(a, x, nhan, expected)
    end
    chay_ca_loi()
    so_sanh_nhi_phan_va_tuyen_tinh()
end

if "--nhap" in ARGS
    nhap_ban_phim()
elseif "--so-sanh" in ARGS
    so_sanh_nhi_phan_va_tuyen_tinh()
else
    ca_chon = [a for a in ARGS if startswith(a, "--ca=")]
    if !isempty(ca_chon)
        i = parse(Int, split(ca_chon[1], '=')[2])
        (1 <= i <= 8) || error("ca $i nam ngoai 1..8")
        if i == 8
            chay_ca_loi()
        else
            a, x, nhan, expected = CAC_CA[i]
            chay_ca(a, x, nhan, expected)
        end
    else
        chay_tat_ca()
    end
end
