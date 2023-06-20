struct Point 
    x::Int 
    y::Int 
end 

struct Direction 
    d::Point 
    n::Int 
end 
const DIRS = Direction(Point(0, 1), 0), Direction(Point(1, 0), 1), Direction(Point(0, -1), 2), Direction(Point(-1, 0), 3)
const NORTH, EAST, SOUTH, WEST = DIRS


Base.:+(p::Point, q::Point) = Point(p.x + q.x, p.y + q.y)
Base.rem(p::Point, x::Int) = Point(p.x % x, p.y % x)
Base.:+(p::Point, d::Direction) = p + d.d 



mutable struct Robot
    p::Point 
    dir::Direction 
end


Robot(t::Tuple{Int, Int}, d::Direction) = Robot(Point(t[1], t[2]), d)
position(r::Robot) = r.p 
heading(r::Robot) = r.dir 


turn_right!(r::Robot) = begin; r.dir = DIRS[(r.dir.n + 1) % 4 + 1]; r; end 
turn_left!(r::Robot) = begin; r.dir = DIRS[(r.dir.n + 3) % 4 + 1]; r; end 


advance!(r::Robot) = begin; r.p += r.dir; r; end 

function move!(r::Robot, s::String)
    for c in s 
        if c == 'A' 
            advance!(r)
        elseif c == 'R'
            turn_right!(r)
        elseif c == 'L' 
            turn_left!(r)
        end 
    end
    r
end

