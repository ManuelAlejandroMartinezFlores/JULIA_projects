f(n) = n % 2 == 0 ? n/2 : 3n + 1

function collatz_steps(n)
    n < 1 ? throw(DomainError(" ")) : n == 1 ? 0 : collatz_steps(f(n)) + 1
end
    