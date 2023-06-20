using CSV, DataFrames, PrettyTables


df = DataFrame(CSV.File("population.csv"))

vscodedisplay(df)


df.id = 1:nrow(df)
select!(df, :id, :)

headers = [:id, :country, :region, :subregion, :wiki18, :wiki19, :wikipct]

rename!(df, headers)

df.wiki18 = parse.(Int, replace.(df.wiki18, "," => ""))
df.wiki19 = parse.(Int, replace.(df.wiki19, "," => ""))

delete!(df, nrow(df))

describe(df)

describe(df, :all)

regions = unique(df.region)
subregions = unique(df.subregion)


sort!(df, :country)

sort!(df, [:region, :subregion, :country])

using Statistics

gdf = groupby(df, :region)

gdfc = combine(gdf,
    :wiki18 => sum,
    :wiki19 => sum, 
    :wiki19 => mean,
)