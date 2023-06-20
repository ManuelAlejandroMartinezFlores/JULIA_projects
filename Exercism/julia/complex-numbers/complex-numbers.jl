struct ComplexNumber <: Number 
    x::Real 
    y::Real 
end 

const jm = ComplexNumber(0, 1)

Base.:+(z1::ComplexNumber, z2::ComplexNumber) = ComplexNumber(z1.x + z2.x, z1.y + z2.y)
Base.:-(z1::ComplexNumber, z2::ComplexNumber) = ComplexNumber(z1.x - z2.x, z1.y - z2.y)
Base.:*(z1::ComplexNumber, z2::ComplexNumber) = ComplexNumber(z1.x * z2.x - z1.y * z2.y, z1.y * z2.x + z2.y * z1.x)
Base.:/(z1::ComplexNumber, z2::ComplexNumber) = ComplexNumber((z1.x * z2.x + z1.y * z2.y) / (z2.x^2 + z2.y^2), (z1.y * z2.x - z2.y * z1.x) / (z2.x^2 + z2.y^2))
Base.isnan(z::ComplexNumber) = isnan(z.x) || isnan(z.y)
Base.isfinite(z::ComplexNumber) = isfinite(z.x) && isfinite(z.y)
Base.abs(z::ComplexNumber) = sqrt(z.x^2 + z.y^2)
Base.isapprox(z1::ComplexNumber, z2::ComplexNumber) = abs(z1 - z2) ≈ 0

Base.conj(z::ComplexNumber) = ComplexNumber(z.x, -z.y)
Base.real(z::ComplexNumber) = z.x
Base.imag(z::ComplexNumber) = z.y 

Base.promote(z::ComplexNumber, x::Real) = z, ComplexNumber(x, 0)
Base.promote(x::Real, z::ComplexNumber) = ComplexNumber(x, 0), z

Base.exp(z::ComplexNumber) = ComplexNumber(exp(z.x) * cos(z.y), exp(z.x) * sin(z.y))


import Base.==
==(z1::ComplexNumber, z2::ComplexNumber) = z1.x == z2.x && z1.y == z2.y

