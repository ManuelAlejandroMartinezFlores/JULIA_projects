using Symbolics


@variables t
pos = 32 + 16t + 8t^2

D = Differential(t)

vel = D(pos)

vel = expand_derivatives(vel)

acc = expand_derivatives(D(vel))

pos0 = substitute(pos, Dict(t => 0))

using SymbolicNumericIntegration

POS = integrate(vel)[1]

P = eval(build_function(POS, t))

P(0)