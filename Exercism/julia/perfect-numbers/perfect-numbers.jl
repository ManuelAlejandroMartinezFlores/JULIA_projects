
aliquot(n) = sum([m for m in 1:(n-1) if n % m == 0])

isperfect(n) = n > 0 ? (aliquot(n) == n) : throw(DomainError(" "))
isabundant(n) = n > 0 ? (aliquot(n) > n) : throw(DomainError(" "))
isdeficient(n) = n > 0 ? (aliquot(n) < n) : throw(DomainError(" "))