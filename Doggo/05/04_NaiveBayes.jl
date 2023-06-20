using DataFrames, CSV, DataFramesMeta


df = DataFrame(CSV.File("tennis.csv"))


function cat(df, cols=nothing)
    cols === nothing ? cols = names(df) : 0
    print(cols)
    d = Dict()
    for col in names(df)
        if col in cols
            u = unique(df[:, col])
            f(s) = findfirst(u .== s)
            d[col] = f.(df[:, col]) 
        else 
            d[col] = df[:, col]
        end
    end 
    DataFrame(d)
end



df = cat(df)
yes = @subset(df, :play .== 2)
no = @subset(df, :play .== 1)

py = count((x) -> x == 2, df.play) / 14
pn = 1. - py

px = Dict()
pxy = Dict()
pxn = Dict()

for c in names(df)
    px_ = @by(df, c, :cnt = length(:play)).cnt
    px[c] = px_ ./ sum(px_)
    pxy_ = @by(@subset(df, :play .== 2), c, :cnt = length(:play)).cnt
    pxy[c] = pxy_ ./ sum(pxy_)
    pxn_ = @by(@subset(df, :play .== 1), c, :cnt = length(:play)).cnt
    pxn[c] = pxn_ ./ sum(pxn_)
end 

pxy


function predict(outlook, humidity, temp, windy)
    d = Dict("outlook" => outlook, "humidity" => humidity,
        "temp" => temp, "windy" => windy)
    pyes = py
    pno = pn
    for n in keys(d)
        d[n] === nothing ? continue : 0
        pyes *= pxy[n][d[n]] / px[n][d[n]]
        pno *= pxn[n][d[n]] / px[n][d[n]]
    end 
    pyes / (pyes + pno)
end

all = [predict(o, h, t, w) for o=1:2 for h=1:2 for t=1:3 for w=1:2]

maximum(all)
