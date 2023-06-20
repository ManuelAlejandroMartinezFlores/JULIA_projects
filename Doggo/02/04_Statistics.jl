using Statistics, StatsBase

data = randn(100);

describe(data)

var(data)

sem(data) #error

using HypothesisTests

diff = vec([-4 -7 -3 -4 -6 -1 1 8 -8 1])

OneSampleTTest(diff)




using LinearAlgebra

O = [175, 25, 100, 100]
E = [137, 62, 137, 63]

ChisqTest(O, normalize(E, 1))