function multiple_argmax(c)
    res = []
    m = -99999
    for i in eachindex(c)
        if m == c[i]
            push!(res, i)
        elseif m < c[i]
            res = [i]
            m = c[i]
        end 
    end 
    res 
end

function multiple_argmin(c)
    res = []
    m = 99999
    for i in eachindex(c)
        if m == c[i]
            push!(res, i)
        elseif m > c[i]
            res = [i]
            m = c[i]
        end 
    end 
    res 
end



function saddlepoints(M)
    length(M) == 0 && return []
    cmax = multiple_argmax.(eachrow(M))
    rmin = multiple_argmin.(eachcol(M))
    h, w = size(M)
    res = []
    for i in 1:h
        for j in 1:w 
            if i in rmin[j] && j in cmax[i]
                push!(res, (i, j))
            end 
        end
    end
    res 
end

