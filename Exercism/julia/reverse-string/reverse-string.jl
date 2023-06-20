
function myreverse(s)
    ss = ""
    gr = collect(Unicode.graphemes(s))
    for id in 1:length(gr)
        ss *= string(gr[end-id+1])
    end 
    ss
end

using Unicode

const TEST_GRAPHEMES = true


@show Unicode.graphemes("hi 👋🏾")