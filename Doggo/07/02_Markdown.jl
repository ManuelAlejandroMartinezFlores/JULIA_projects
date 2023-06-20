### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 0ad98276-0867-11ee-08bc-07b6ba75bbf4
md"""
# Markdown
"""

# ╔═╡ 3efe1b72-e5d0-4131-8942-ce1f76939b4f
md"""
## Formatting
"""

# ╔═╡ a8ab5ff9-da29-4880-a5dd-88b0f89d81d4
md"""
*italics*
"""

# ╔═╡ 8d23b0cd-6bbb-4831-86dd-120150d1daec
md"""
**bold**
"""

# ╔═╡ 651212d4-43c1-463d-a155-dd76bd050fab
md"""
## Blockquote
"""

# ╔═╡ d98ba686-fd8a-44f5-8920-7184bcc04152
md"""
>The number of sequential code characters indicate the width of the code. A format of yyyy-mm specifies that the code y should have a width of four while m a width of two. Codes that yield numeric digits have an associated mode: fixed-width or minimum-width. The fixed-width mode left-pads the value with zeros when it is shorter than the specified width and truncates the value when longer. Minimum-width mode works the same as fixed-width except that it does not truncate values longer than the width.
"""

# ╔═╡ 8ee78afb-e356-43c6-8b77-afc620af03b1
md"""
## Code Block
"""

# ╔═╡ 8333b328-733e-4820-bb79-68f9c096c7ae
md"""```julia
function myadd(x::Int, y)
	return x + y
end
```"""

# ╔═╡ fcdddc81-a74a-4ba8-bd7d-1fb1242f97c3
md"""
insert inline `println()` code
"""

# ╔═╡ 093cba93-c258-49b1-aea6-f580b0cded31
md"""
## Lists
"""

# ╔═╡ d41ecfe4-dfb8-4320-bfe5-644b18e47f0b
md"""
1. first
2. second
"""

# ╔═╡ 653d8dbc-4e96-4a9b-b6e6-ac8d188fbe20
md"""
* first
* second
"""

# ╔═╡ 8e034c51-d1b4-408d-9f2f-1c89af074430
md"""
## Table
"""

# ╔═╡ e357d646-f381-4c09-9322-f9a5738d0ac9
md"""
| name | title |
| ---- | ----- |
| doggo | ceo |
"""

# ╔═╡ 6cc8ba15-c4f3-471d-bdc3-8841abe32a0c
md"""
## Unicode
"""

# ╔═╡ 8a71f5ea-3fbd-4d56-b962-96e3a06813ca
md"""
H\_2<tab>O displays as H₂O
"""

# ╔═╡ af9e9bd1-7abe-48eb-ac33-8dc48ad2dde8


# ╔═╡ Cell order:
# ╠═0ad98276-0867-11ee-08bc-07b6ba75bbf4
# ╠═3efe1b72-e5d0-4131-8942-ce1f76939b4f
# ╠═a8ab5ff9-da29-4880-a5dd-88b0f89d81d4
# ╠═8d23b0cd-6bbb-4831-86dd-120150d1daec
# ╠═651212d4-43c1-463d-a155-dd76bd050fab
# ╠═d98ba686-fd8a-44f5-8920-7184bcc04152
# ╠═8ee78afb-e356-43c6-8b77-afc620af03b1
# ╠═8333b328-733e-4820-bb79-68f9c096c7ae
# ╠═fcdddc81-a74a-4ba8-bd7d-1fb1242f97c3
# ╠═093cba93-c258-49b1-aea6-f580b0cded31
# ╠═d41ecfe4-dfb8-4320-bfe5-644b18e47f0b
# ╠═653d8dbc-4e96-4a9b-b6e6-ac8d188fbe20
# ╠═8e034c51-d1b4-408d-9f2f-1c89af074430
# ╠═e357d646-f381-4c09-9322-f9a5738d0ac9
# ╠═6cc8ba15-c4f3-471d-bdc3-8841abe32a0c
# ╠═8a71f5ea-3fbd-4d56-b962-96e3a06813ca
# ╠═af9e9bd1-7abe-48eb-ac33-8dc48ad2dde8
