versioninfo()

Threads.nthreads()

Threads.threadid()

# Single threaded


for i in 1:Threads.nthreads()
    println("i: $i\t ThreadID: $(Threads.threadid())")
end

# Multi Threaded

Threads.@threads for i in 1:Threads.nthreads()
    println("i: $i\t ThreadID: $(Threads.threadid())")
end



########################################
# Data Race
########################################

n = 1_000_000

v = collect(1:n)

s = sum(v)

function multisum1(v)
    s = 0
    for i in eachindex(v)
        s += v[i]
    end 
    s 
end

s == multisum1(v)

function multisum2(v)
    s = 0
    Threads.@threads for i in eachindex(v)
        s += v[i]
    end 
    s 
end

multisum2(v)
s == multisum2(v)


# Solution 
function multisum(v) 
    s = zeros(eltype(v), Threads.nthreads())
    Threads.@threads for i in eachindex(v)
        s[Threads.threadid()] += v[i]
    end 
    println(s)
    sum(s)
end

s == multisum(v)

