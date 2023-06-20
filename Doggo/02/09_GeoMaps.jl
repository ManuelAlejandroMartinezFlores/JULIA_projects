using VegaLite, VegaDatasets


us10m = dataset("us-10m")


p = @vlplot(
    width=640, 
    height=360, 
    title="US",
    projection= {type = :albersUsa},
    data = {
        values = us10m, 
        format = {
            type = :topojson, 
            feature = :states
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)



canvas =  @vlplot(
    width=640, 
    height=360, 
    title="US",
    projection= {type = :albersUsa},
    title="Texas",
)

stmap = @vlplot(
    data = {
        values = us10m, 
        format = {
            type = :topojson,
            feature = :states
        }
    },
    transform = [{
        filter = {
            field = :id, 
            equal = 48
        }
    }],
    mark = {
        type = :geoshape, 
        fill = :lightgray,
        stroke = :width
    }
)

tx = canvas + stmap



capitals = dataset("us-state-capitals")

canvas =  @vlplot(
    width=640, 
    height=360, 
    title="US",
    projection= {type = :albersUsa},
    title="capitals",
)

usmap = @vlplot(
    data = {
        values = us10m, 
        format = {
            type = :topojson, 
            feature = :states
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)


cap = @vlplot(
    data = capitals,
    mark = :circle, 
    latitude = "lat:q",
    longitude = "lon:q",
    color = {value = :red}
)

nam = @vlplot(
    data = capitals,
    mark = {
        type = :text, 
        dy = 8, 
        fontSize = 6
    },
    latitude = "lat:q",
    longitude = "lon:q",
    text = "city:n",
)

p = canvas + usmap + cap + nam





canvas =  @vlplot(
    width=640, 
    height=360, 
    title="US",
    projection= {type = :albersUsa},
    title="county",
)

usmap = @vlplot(
    data = {
        values = us10m, 
        format = {
            type = :topojson, 
            feature = :counties
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

p = canvas + usmap


unemp = dataset("unemployment")


canvas =  @vlplot(
    width=640, 
    height=360, 
    projection= {type = :albersUsa},
    title="unemployment",
)

usmap = @vlplot(
    data = {
        values = us10m, 
        format = {
            type = :topojson, 
            feature = :counties
        }
    },
    transform = [{
        lookup = :id, 
        from = {
            data = unemp,
            key = :id,
            fields = ["rate"]
        }
    }],
    mark = :geoshape,
    color = "rate:q"
)

p = canvas + usmap



w110m = dataset("world-110m")

canvas =  @vlplot(
    width=640, 
    height=360, 
    projection= {type = :equalEarth},
    title="world",
)

wmap = @vlplot(
    data = {
        values = w110m, 
        format = {
            type = :topojson, 
            feature = :countries
        }
    },
    mark = {
        type = :geoshape,
        fill = :lightgray,
        stroke = :white
    }
)

p = canvas + wmap