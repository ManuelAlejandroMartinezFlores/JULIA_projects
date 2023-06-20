struct RationalNumber{T} <: Real 
    num::T
    den::T 
    RationalNumber{T}(num::Int, den::Int) where T = begin 
        num == den == 0 && throw(ArgumentError(" "))
        d = gcd(num, den)
        num = flipsign(num, den)
        den = abs(den)
        new{T}(round(Int, num / d), round(Int, den / d))
    end 
end 

RationalNumber(num::Int, den::Int) = RationalNumber{Int}(num, den)

Base.sprint(f::Function, r::RationalNumber) = "$(r.num)//$(r.den)"
Base.show(io::IO, ::MIME"text/plain", r::RationalNumber) = print(io, "$(r.num)//$(r.den)") 


Base.zero(::Type{RationalNumber{T}}) where T = RationalNumber{T}(zero(T), one(T))
Base.one(::Type{RationalNumber{T}}) where T = RationalNumber{T}(one(T), one(T))
 


import Base.==

==(r1::RationalNumber, r2::RationalNumber) = r1.num == r2.num && r1.den == r2.den



Base.promote(x::Int, r::RationalNumber) = RationalNumber(x, 1), r 
Base.promote(r::RationalNumber, x::Int) = r, RationalNumber(x, 1)
Base.promote(x::Real, r::RationalNumber) = promote(x, r.num / r.den)
Base.promote(r::RationalNumber, x::Real) = promote(r.num / r.den, x)


Base.:+(r1::RationalNumber, r2::RationalNumber) = RationalNumber(r1.num * r2.den + r2.num * r1.den, r1.den * r2.den)
Base.:-(r1::RationalNumber, r2::RationalNumber) = RationalNumber(r1.num * r2.den - r2.num * r1.den, r1.den * r2.den)
Base.:*(r1::RationalNumber, r2::RationalNumber) = RationalNumber(r1.num * r2.num, r1.den * r2.den)
Base.:/(r1::RationalNumber, r2::RationalNumber) = RationalNumber(r1.num * r2.den, r1.den * r2.num)

Base.:^(x::Real, r::RationalNumber) = x ^ (r.num / r.den )


Base.abs(r::RationalNumber) = RationalNumber(abs(r.num), abs(r.den))

Base.numerator(r::RationalNumber) = r.num 
Base.denominator(r::RationalNumber) = r.den 


import Base.<, Base.>


<(r1::RationalNumber, r2::RationalNumber) = (r1.num / r1.den) < (r2.num / r2.den) 
>(r1::RationalNumber, r2::RationalNumber) = (r1.num / r1.den) > (r2.num / r2.den) 

