# scripts/test_catalog.jl — In danh mục input/expected/actual/PASS cho các ca DT028.
# Lệnh: julia --startup-file=no scripts/test_catalog.jl

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

# (id, nhãn, mảng, x, expected (dau, cuoi, count))
const CAT = [
    ("VD01",   "Vi du 1 phieu",          [1, 2, 2, 2, 4],             2,  (2, 4, 3)),
    ("VD02",   "Vi du 2 phieu (vang)",   [1, 2, 2, 2, 4],             3,  (0, 0, 0)),
    ("TK01",   "Tu thiet ke 1 (dau)",    [1, 1, 1, 5, 9],             1,  (1, 3, 3)),
    ("TK02",   "Tu thiet ke 2 (cuoi)",   [0, 3, 7, 7],                7,  (3, 4, 2)),
    ("BIEN01", "Ca phieu 4: [1,2] x=1",   [1, 2],                       1,  (1, 1, 1)),
    ("BIEN02", "Ca phieu 5: mang rong",   Int[],                       5,  (0, 0, 0)),
    ("BIEN03", "Ca phieu 3: [5,5,5]",     [5, 5, 5],                   5,  (1, 3, 3)),
    ("KT09",   "Mot phan tu",             [5],                         5,  (1, 1, 1)),
    ("KT10",   "Nho hon moi phan tu",     [2, 4, 6],                   1,  (0, 0, 0)),
    ("KT11",   "Lon hon moi phan tu",     [2, 4, 6],                   9,  (0, 0, 0)),
    ("KT12",   "Khoa trung o giua",       [1, 3, 3, 3, 3, 5, 7, 7],   3,  (2, 5, 4)),
    ("KT13",   "So am",                   [-5, -5, -2, 0],            -5,  (1, 2, 2)),
]

function chay_danh_muc()
    pass = 0
    for (id, nhan, a, x, exp) in CAT
        kiem_tra_dau_vao(a)
        kq = tan_suat(a, x)
        ok = (kq.dau, kq.cuoi, kq.count) == exp
        pass += ok ? 1 : 0
        println(rpad(id, 9), " | ", rpad(nhan, 22), " | a=", a, " x=", x,
                " | expected=", exp, " | actual=", (kq.dau, kq.cuoi, kq.count),
                " | xet_mid=", kq.xet_dau + kq.xet_cuoi, " | ", ok ? "PASS" : "FAIL")
    end
    println("TONG KET: ", pass, "/", length(CAT), " ca PASS")
    return pass == length(CAT)
end

ok = chay_danh_muc()
ok || error("co ca FAIL")
