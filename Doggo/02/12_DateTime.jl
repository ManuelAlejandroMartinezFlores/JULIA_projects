using Dates

d = Date(2021, 3, 11)

dt = DateTime(21021, 3, 20, 14, 20, 45)

Date("2020-10-3")

Time("10:20:45")

using DataFrames, CSV 


df = DataFrame(CSV.File("dates.csv", delim="#"))

#=
y: year
m: month
d: day 
U: full name month 
u: abbr. name month
=#


formats = [
    "y-m-d",
    "y U d",
    "d U y",
    "U d, y",
    "y.m.d",
    "y/m/d",
    "d.m.y",
    "d/m/y",
    "d-m-y",
    "m/d/y",
    "m-d-y",
    "m-d-y",
    "m/d/y",
    "m/d/y"
]

df.ISO = Date.(df.dates, formats)

df.ISO[11:14] .+= Year(2000)


df = DataFrame(CSV.File("times.csv", delim="#"))

#=
HH: 24 hour 
I, II: 12 hour num digits 
MM: minute 
p: AM or PM 
=#

formats = [
    "HH:MM",
    "I:MMp",
    "I:MMp",
    "I:MM p",
    "I:MM p",
    "HH:MM",
    "I:MMp",
    "I:MMp",
    "I:MM p",
    "I:MM p"
]

df.ISO = Time.(df.times, formats)