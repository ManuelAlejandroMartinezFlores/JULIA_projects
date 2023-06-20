# Change any of the following NamedTuple values to true to 
# enable testing different bonus tasks
tested_bonus_tasks = (rev = true, by = true, lt = true, multiple_matches = true)


function binarysearch(list, value, n=0; lt=<, rev=false, by=x->x, multiple_matches=true)
    idx = search(list, value, 0; lt, rev, by)
    
    if !multiple_matches
        return idx 
    else 
        length(idx) == 0 && return idx
        minid = minimum(idx)
        maxid = maximum(idx)
        while minid > 1 
            temp = search(list[1:minid-1], value, 0; lt, rev, by)
            if length(temp) != 0 
                minid = minimum(temp)
            else 
                break 
            end 
        end 
        while maxid < length(list) 
            temp = search(list[maxid+1:end], value, maxid; lt, rev, by)
            if length(temp) != 0 
                maxid = maximum(temp)
            else 
                break 
            end 
        end 
        return minid:maxid
    end 
end


function search(list, value, n=0; lt=<, rev=false, by=x->x)
    list = by.(list)
    value = by(value)
    if rev 
        lt = !lt
    end
    if length(list) == 0
        return 1:0 
    end
    if length(list) == 1
        el = list[1]
        if el == value 
            return (n+1):(n+1)
        elseif  lt(el, value)
            return (n+2):(n+1)
        else 
            return (n+1):n
        end
    end
    if length(list) % 2 == 0
        m = round(Int, length(list) / 2)
        if lt(list[m], value)
            return search(list[(m+1):end], value, m+n; lt)
        else 
            return search(list[1:m], value, n; lt)
        end
    else 
        m = round(Int, (length(list) + 1 )/ 2)
        if list[m] == value 
            return (m+n):(m+n)
        elseif lt(list[m], value)
            return search(list[(m+1):end], value, m+n; lt)
        else 
            return search(list[1:(m-1)], value, n; lt)
        end 
    end
end
