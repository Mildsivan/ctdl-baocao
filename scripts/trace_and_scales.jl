# scripts/trace_and_scales.jl — Truy vết tay T01 và khảo sát quy mô DT028.
# Lệnh: julia --startup-file=no scripts/trace_and_scales.jl

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai
using Random

function truy_vet_t01()
    a = [1, 2, 2, 2, 4]
    x = 2
    println("="^78)
    println("TRUY VET T01 (Vi du 1): a = ", a, ", x = ", x)
    kq = lan_vet_tim_bien(a, x)
    println("Tong hop: first = ", kq.dau, ", last = ", kq.cuoi, ", count = ", kq.count)
    println("Tong so lan xet mid = ", kq.xet_dau, " + ", kq.xet_cuoi,
            " = ", kq.xet_dau + kq.xet_cuoi)
    println()
end

function khao_sat_quy_mo()
    println("="^78)
    println("KHAO SAT QUY MO: nhi phan (2 lan tim) so voi quet tuyen tinh")
    Random.seed!(28062026)
    for n in (5, 50, 500, 5000)
        a = sort!(rand(1:20, n))          # mảng tăng, nhiều khóa trùng
        x = a[n ÷ 2 + 1]                  # x chắc chắn có mặt
        kq = tan_suat(a, x)
        lt = quet_tuyen_tinh(a, x)
        log_lt = ceil(Int, log2(n + 1))
        println("n = ", rpad(n, 5),
                " | count = ", rpad(kq.count, 4),
                " | xet mid: dau = ", rpad(kq.xet_dau, 2), ", cuoi = ", rpad(kq.xet_cuoi, 2),
                " (tong = ", rpad(kq.xet_dau + kq.xet_cuoi, 2), ", tran 2*ceil(log2(n+1)) = ", 2 * log_lt, ")",
                " | tuyen tinh = ", lt.so_sanh, " phep so sanh")
        # Đo thời gian tương đối, lấy tốt nhất trong 5 lần.
        best = typemax(Int64)
        for _ in 1:5
            t0 = time_ns()
            tan_suat(a, x)
            best = min(best, time_ns() - t0)
        end
        println("        thoi gian tot nhat ~ ", round(best / 1e3, digits=1), " us")
    end
    println()
    println("Nhan xet: so lan xet mid cua moi lan tim khong vuot ceil(log2(n+1)) + 1;")
    println("quet tuyen tinh co the cham hon nhieu khi mang lon va x nam gan cuoi.")
    println()
end

truy_vet_t01()
khao_sat_quy_mo()
println("HOAN TAT TRUY VET VA KHAO SAT QUY MO.")
