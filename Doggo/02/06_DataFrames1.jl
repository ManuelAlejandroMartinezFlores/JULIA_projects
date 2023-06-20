

brand = ["a", "b", "c"]
tier = ["p", "e", "s"]
quantity = [10, 100, 50]
price = [100, 10, 50]
cost = [30, 7, 25]


matrix = [brand tier quantity price cost]


rev = matrix[:, 3] .* matrix[:, 4]

matrix = [matrix rev]

profit = quantity .* (price - cost)

matrix = [matrix profit]

margin = profit ./ rev

matrix = [matrix margin]


using DelimitedFiles

writedlm("matrix.csv", matrix, ",")


################################################
################################################

using TypedTables

table = Table(
    brand = brand,
    tier = tier,
    quantity = quantity,
    price = price,
    revenue = rev,
    profit = profit,
    margin = margin
)

table.tier

using CSV

CSV.write("table.csv", table)


using PrettyTables

ptable = pretty_table(table)


function savehtml(fname, data)
    open("$fname.html", "w") do f 
        pretty_table(f, data, backend=Val(:html))
    end 
end

function savelatex(fname, data)
    open("$fname.tex", "w") do f 
        pretty_table(f, data, backend=Val(:latex))
    end 
end

savehtml("pretty_table", table)
savelatex("pretty_table", table)



################################################
################################################

using DataFrames


df = DataFrame(table)

describe(df)

rename(df, :brand => :company)

df

rename!(df, :brand => :company)

df