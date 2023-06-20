"""Calculate the number of grains on square `square`."""
function on_square(square)
    65 > square > 0 || throw(DomainError(" "))
    exp2(square-1)
end

"""Calculate the total number of grains after square `square`."""
function total_after(square)
    65 > square > 0 || throw(DomainError(" "))
    square = Int128(square)
    round(Int128, exp2(square)) - 1
end
