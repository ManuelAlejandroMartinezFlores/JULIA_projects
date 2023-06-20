using VegaDatasets, DataVoyager, VegaLite

data = dataset("iris")


vscodedisplay(data)


v = Voyager(data)

p = v[]