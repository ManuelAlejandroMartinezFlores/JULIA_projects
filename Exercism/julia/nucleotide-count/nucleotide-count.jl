"""
    count_nucleotides(strand)

The count of each nucleotide within `strand` as a dictionary.

Invalid strands raise a `DomainError`.

"""
function count_nucleotides(strand)
    D = Dict('A' => 0, 'C' => 0, 'G' => 0, 'T' => 0)
    unique_nuc = unique(strand)
    for n in unique_nuc
        n in keys(D) || throw(DomainError(" "))
    end
    for n in strand
        D[n] += 1
    end
    D
end
