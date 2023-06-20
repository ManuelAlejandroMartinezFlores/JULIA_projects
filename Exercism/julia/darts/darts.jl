function score(x, y)
    dist = sqrt(x^2 + y^2)
    dist <= 1 ? (return 10) : dist <= 5 ? (return 5) : dist <= 10 ? (return 1) : (return 0)
end
