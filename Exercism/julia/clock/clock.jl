using Dates

struct Clock 
    t::Dates.Time
end 

Clock(h::Int, m::Int) = begin
    hp = (h + floor(m / 60)) % 24
    mp = m % 60
    if hp < 0
        hp = 24 + hp
    end
    if mp < 0 
        mp = 60 + mp 
    end
    Clock(Time(hp, mp))
end

Clock(24, 0) == Clock(0, 0)

Base.:+(c1::Clock, c2::Clock) = Clock(c1.t + c2.t)
Base.:-(c1::Clock, c2::Clock) = Clock(c1.t - c2.t)
Base.:+(c::Clock, t::T) where T <: TimePeriod = Clock(c.t + t)
Base.:-(c::Clock, t::T) where T <: TimePeriod = Clock(c.t - t)

sprint(show, c::Clock) = "\"" * string(c.t)[1:5] * "\""

import Base.string

string(c::Clock) = string(c.t)[1:5]
    