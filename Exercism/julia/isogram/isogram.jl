function isisogram(s)
    s = lowercase(s)
    s = replace(s, r"\W" => "")
    un = unique(s)
    length(s) == length(un)
end
