mutable struct Node{T}
    next::Node{T}
    val::T 
    Node{T}() where T = new{T}()
    Node(n::Node{T}) where T = new{T}(n)
    Node(n::Node{T}, x::Int) where T = new{T}(n, x)
end


Node() = Node{Any}()



mutable struct CircularBuffer{T} <: AbstractVector{T}
    cap::Int 
    h::Node{T}
    len::Int 
    function CircularBuffer{T}(capacity::Integer) where {T}
        h = Node{T}()
        n = h
        for i in 1:(capacity - 1) 
            np = Node{T}()
            n.next = np
            n = np 
        end 
        n.next = h
        new(capacity, h, 0)
    end
end

Base.length(c::CircularBuffer) = c.len
Base.size(c::CircularBuffer) = (c.len, )
capacity(cb::CircularBuffer) = cb.cap 




Base.getindex(cb::CircularBuffer, key::Int) = begin 
    key > cb.len && throw(BoundsError(" ")) 
    key > 0 || throw(BoundsError(" ")) 
    n = cb.h 
    for i in 1:(key - 1)
        n = n.next 
    end 
    n.val 
end  

Base.getindex(cb::CircularBuffer, keys) = [cb[i] for i in keys]

Base.getindex(cb::CircularBuffer, keys...) = [cb[i] for i in keys]


Base.setindex!(cb::CircularBuffer, value, key::Int) = begin 
    key > cb.len && throw(BoundsError(" ")) 
    key > 0 || throw(BoundsError(" ")) 
    n = cb.h 
    for i in 1:(key - 1)
        n = n.next 
    end 
    n.val = value 
    cb 
end 





function Base.push!(cb::CircularBuffer, item; overwrite::Bool=false)
    overwrite || (cb.len == cb.cap && throw(BoundsError(" "))) 
    
    n = cb.h
    for i in 1:cb.len
        n = n.next 
    end
    n.val = item 
    if overwrite && cb.len == cb.cap
        cb.h = n.next
    end
    if cb.len < cb.cap  
        cb.len += 1 
    end 
    cb
end

Base.push!(cb::CircularBuffer, items...; overwrite::Bool=false) = begin 
    for i in items 
        push!(cb, i; overwrite=overwrite)
    end 
    cb
end



function Base.popfirst!(cb::CircularBuffer)
    cb.len > 0 || throw(BoundsError(" "))
    h = cb.h 
    cb.h = h.next 
    cb.len -= 1
    h.val 
end


function Base.empty!(cb::CircularBuffer)
    cb.len = 0 
    cb 
end


isfull(cb::CircularBuffer) = cb.len == cb.cap


Base.append!(cb::CircularBuffer, items...; overwrite::Bool=false) = begin
    for i in items 
        push!(cb, i...; overwrite=overwrite) 
    end 
    cb 
end 


Base.pushfirst!(cb::CircularBuffer, value; overwrite::Bool=false) = begin 
    overwrite || (cb.len == cb.cap && throw(BoundsError(" ")))
    n = cb.h 
    for i in 1:(cb.cap - 1)
        n = n.next 
    end 
    n.val = value 
    cb.h = n 
    if cb.len < cb.cap 
        cb.len += 1 
    end 
    cb 
end 


Base.pop!(cb::CircularBuffer) = begin
    cb.len == 0 && throw(BoundsError(" "))
    v = cb[cb.len]
    cb.len -= 1 
    v 
end

