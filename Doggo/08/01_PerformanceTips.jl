n = 100_000_000

a = 2.718

x = rand(n); y = rand(n);

z = []


@time for i in 1:n 
    temp = a * x[i] + y[i]
    push!(z, temp)
end

function axpy(a, x, y)
    z = []
    for i in 1:length(x)
        temp = a * x[i] + y[i]
        push!(z, temp)
    end
end 


@time axpy(a, x, y)

@time z = a * x + y


@time @. z = a * x + y


using LinearAlgebra

@time LinearAlgebra.axpy!(a, x, y)




############################################
# Profile
############################################

function func()
    A = rand(200, 200, 400)
    maximum(A)
end

using Profile

@profile func()

Profile.print()

@profview func()

@profview_allocs func() sample_rate=1