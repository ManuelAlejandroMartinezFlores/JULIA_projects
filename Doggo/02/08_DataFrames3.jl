using CSV, DataFrames, DataFramesMeta

df = DataFrame(CSV.File("population.csv"))

vscodedisplay(df)


df.id = 1:nrow(df)
select!(df, :id, :)

headers = [:id, :country, :region, :subregion, :wiki18, :wiki19, :wikipct]

rename!(df, headers)

df.wiki18 = parse.(Int, replace.(df.wiki18, "," => ""))
df.wiki19 = parse.(Int, replace.(df.wiki19, "," => ""))

delete!(df, nrow(df))


dff = filter(:region => x -> x == "Asia", df)

dff = @subset(df, :region .== "Asia")

dff = @subset(df, (:region .== "Asia") .| (:region .== "Americas"))


dfb = @by(df, :region,
    :sum18 = sum(:wiki18)
)



using Gadfly

set_default_plot_size(1020px, 750px)

sort!(dfb, :sum18)

p = plot(dfb,
    x = :sum18,
    y = :region, 
    color = :region,
    Geom.bar(orientation=:horizontal),
    Guide.xlabel("p"),
    Guide.xlabel("region"),
    Guide.title("title"),
    Guide.colorkey(title="region"),
    Scale.x_continuous(format=:plain),
    Theme(
        background_color = "white",
        bar_spacing = 1mm
    )
)