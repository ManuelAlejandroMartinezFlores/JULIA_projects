abstract type ASet{T} end

struct ESet{T} <: ASet{T} end

struct NSet{T} <: ASet{T}
    h::T 
    t::H where H<:ASet{T}
end

mutable struct CustomSet{T} <: Base.AbstractSet{T}
    val::H where H<:ASet{T}
end



######### Constructors ############

ASet{T}() where T = ESet{T}()
ASet() = ASet{Any}()

ASet(s::ESet{T}) where T = ASet{T}()
ASet(s::NSet{T}) where T = NSet{T}(s.h, ASet(s.t))
ASet(h, t::H) where H<:ASet = NSet(h, t)

ASet(a::Array{T}) where T = length(a) == 0 ? ASet{T}() : ASet(first(a), ASet(a[2:end]))


CustomSet{T}() where T = CustomSet(ASet{T}())
CustomSet() = CustomSet(ASet{Int}())
CustomSet(h, t::H) where H<:ASet = CustomSet(ASet(h, t))
CustomSet(c::CustomSet) = CustomSet(ASet(c.val))

Base.convert(::Type{ESet{T}}, s::ESet) where T = ESet{T}()
Base.convert(::Type{ASet{T}}, s::ESet) where T = ASet{T}()
Base.convert(::Type{<:ASet{T}}, s::NSet) where T = ASet(convert(T, s.h), convert(ASet{T}, s.t))


######### Iteration ############


Base.iterate(c::CustomSet{T}, state=1) where T = begin 
    x = c.val 
    for n in 1:(state-1) 
        try 
            x = x.t 
        catch 
            return nothing
        end 
    end 
    try
        return x.h, state+1
    catch 
        return nothing
    end 
end 


Base.length(s::ESet) = 0

Base.length(s::NSet) = 1 + length(s.t)
Base.length(s::CustomSet) = length(s.val)



######### Is Empty ############
import Base.isempty
Base.isempty(c::CustomSet) = length(c) == 0

######### In ############
import Base.in
in(x, s::ESet) = false 
in(x, s::NSet) = x == s.h || in(x, s.t)
in(x, s::CustomSet) = x in s.val


######### Push  ############

push(s::H, x) where H<:ASet = x in s ? ASet(s) : ASet(x, ASet(s))
Base.push!(s::CustomSet{T}, x::T) where T = begin; s.val = push(s.val, x); s; end 
push(s::CustomSet, x) = CustomSet(push(s.val, x))


######### List Constructors ############

ASet(a::Array{T}) where T = length(a) == 0 ? ASet{T}() : push(ASet(a[2:end]), first(a)) 
CustomSet(a::Array{T}) where T = CustomSet(ASet(a))


######### Subset ############

Base.issubset(c::ESet, s::H) where H<:ASet = true 
Base.issubset(c::NSet, s::H) where H<:ASet = c.h in s && Base.issubset(c.t, s)

######### Equality ############

import Base.==

==(c::CustomSet, s::CustomSet) = issubset(c, s) && issubset(s, c)


######### Intersect ############

Base.intersect(s::ESet, c::NSet{T}) where T = ASet{T}()
Base.intersect(s::ESet{T}, c::ESet) where T = ASet{T}()
Base.intersect(s::NSet{T}, c::ESet) where T = ASet{T}()
Base.intersect(s::NSet, c::NSet) = s.h in c ? push(intersect(s.t, c), s.h) : intersect(s.t, c)
Base.intersect(s::CustomSet, c::CustomSet) = CustomSet(intersect(s.val, c.val))

Base.intersect!(s::CustomSet, c::CustomSet) = begin; s.val = intersect(s.val, c.val); s; end 



######### Disjoint ############]

Base.isdisjoint(s::CustomSet, c::CustomSet) = isempty(intersect(s, c))

disjoint(s::CustomSet, c::CustomSet) = isdisjoint(s, c)


######### Complement ############

complement(c::ESet, s::H) where H<:ASet = ASet(c)
complement(c::NSet, s::H) where H<:ASet = c.h in s ? complement(c.t, s) : push(complement(c.t, s), c.h)
complement(c::CustomSet, s::CustomSet) = CustomSet(complement(c.val, s.val))
complement!(c::CustomSet, s::CustomSet) = begin; c.val = complement(c.val, s.val); c; end


######### Union  ############

Base.union(c::ESet, s::H) where H<:ASet = ASet(s)
Base.union(c::NSet, s::H) where H<:ASet = push(union(c.t, s), c.h)
Base.union(c::CustomSet, s::CustomSet) = CustomSet(union(c.val, s.val))
Base.union!(c::CustomSet, s::CustomSet) = begin; c.val = union(c.val, s.val); c; end 



######### Copy  ############

Base.copy(c::CustomSet) = CustomSet(c)



