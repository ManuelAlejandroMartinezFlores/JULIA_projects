function add_gigasecond(date::DateTime)
    date + Second(exp10(9))
end
