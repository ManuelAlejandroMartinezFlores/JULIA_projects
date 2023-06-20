using Distributed

addprocs(10)

@time for i in 2:nprocs()
    sleep(1)
end


@time @sync for i in 2:nprocs()
    @spawnat i sleep(1)
end

@time for i in 2:nprocs()
    println("hello")
end

@time @sync for i in 2:nprocs()
    @spawnat i println("hello")
end

##########################################
##########################################

##########################################

procs()

rmprocs(11)

procs()

w = workers()

a1 = @spawnat w[1] rand(3, 4)

fetch(a1)

a2 = @spawnat :any sum(1:10)

fetch(a2)

@everywhere using Statistics


a5 = @spawnat w[4] mean(rand(100))
fetch(a5)

using SharedArrays

data = SharedArray(rand(10))

@everywhere using Plots

a8 = @spawnat w[3] plot(data)

fetch(a8)


##########################################
##########################################

##########################################

using Distributed


rmprocs([6, 7, 8, 9, 10])
w = workers()

using SharedArrays
n = 1_000
data = SharedMatrix(rand(n, n))
x = data[:, 1]
y = data[:, 2]

@everywhere include("04_MyFuncs.jl")
@everywhere using .MyFuncs

@everywhere using Plots

t1 = @spawnat w[1] task1(data)
t2 = @spawnat w[2] task2(data)
t3 = @spawnat w[3] task3(data)

t4 = @spawnat w[4] scatter(x, y, legend=false)

fetch(t1)
fetch(t2)
fetch(t3)
fetch(t4)