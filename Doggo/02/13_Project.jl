using Dates, Statistics

using CSV, DataFrames, DataFramesMeta, GLMakie, PrettyTables

df = DataFrame(CSV.File("review.csv"))

vscodedisplay(df)

df.length = Time.(string.(df.length), "M:S:s")

df.date = Date.(df.date, "m/d/y") .+ Year(2000)

df.year = year.(df.date)

cat = @by(df, :category,
    :inall = sum(in.([2012, 2013, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020], [:year for _ in 1:10])))

cat = @subset(cat, :inall .== 10).category



df = @subset(df, @byrow :category in cat)



Makie.inline!(false)

fig = Figure(resolution = (1080, 720))

ax1 = Axis(fig[1, 1], aspect = 1.5, title = "Review", 
    xlabel = "metric", xticks = LinearTicks(15), 
    ylabel = "density", yticks = LinearTicks(10), 
    limits = (nothing, nothing, 0, nothing)
)

metric = [:rating, :price]
metricmenu = Menu(fig, options = metric)

years = [999, unique(df.year)...]
yname = string.(years)
yname[1] = "all"
yearmenu = Menu(fig, options = zip(yname, years))

categ = ["all categories", cat...]
catmenu = Menu(fig, options = categ, width=200)

fig[1, 2] = vgrid!(
    Label(fig, "metric"), metricmenu, 
    Label(fig, "year"), yearmenu,
    Label(fig, "category"), catmenu, 
    tellheight = false, width=200
)

mc = Observable(metric[1])
yr = Observable(years[1])
ct = Observable(cat[1])

m = @lift(
    @subset(df, ($ct .== "all categories" .|| :category .== $ct) .&&
            ($yr .== 999 .|| :year .== $yr))[:, $mc]
)


den1 = density!(ax1, m, 
    color = (:teal, 0.5), strokecolor = :black, strokewidth = 2
)


on(metricmenu.selection) do select 
    mc[] = select 
end 
on(yearmenu.selection) do select 
    yr[] = select 
end 
on(catmenu.selection) do select 
    ct[] = select 
end