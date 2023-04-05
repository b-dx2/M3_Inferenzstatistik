### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a61e79d0-b44d-11ed-0f75-c3c2abe12679
using Distributions, PlutoUI, StatsPlots , Random

# ╔═╡ 7aad9fe9-6e20-4116-9c06-279f6794370d
using KernelDensity, Plots

# ╔═╡ 0f455005-3900-4feb-9464-47a092e5a9dd
@bind m Slider(80:120)

# ╔═╡ 092f10fb-38c6-4a2c-baad-e542191495df
@bind sd Slider(0.5:0.5:2)

# ╔═╡ 521c8a2d-71e6-4b3c-84f4-8295815196c2
d = Normal(m, sd)

# ╔═╡ b5eff4c2-e59d-4712-84cd-02ad17681477
n = 10

# ╔═╡ 6d5312c6-88a1-4c52-8e01-19fb7d0be82a
p = 0.5

# ╔═╡ 637ee94b-6f99-4940-b628-3e7593c00226
begin
	plot(Binomial(n, p), lw=3, legend=false, fill=(0.1,0,:red))
	title!("B($(n),$(p))")
	# plot!(range(-z*sd+m, stop=z*sd+m, length=100), Normal(m, sd), lw=3, legend=false, fill=(0.2,0,:green))
	#new_xticks2 = ([-sd+m,m, m, sd+m], ["-sd", "\$\\bar \\m\$", "sd"])
	#vline!(new_xticks2[1], lw=3)
end

# ╔═╡ 978f7bd6-bfb0-4dd7-a2ce-dfe7c76d43a4
B1 = rand(Binomial(1, p),10)'

# ╔═╡ 6f2f1b70-0e2c-499b-b6ee-d02012fac06f
@bind dice Select(["H" => "🍎", "T" => "🍉"])

# ╔═╡ 27ba5d8b-2021-4f2a-af58-ebfa9e55b357
replace(B1, "0"=>"H", "1"=>"T")

# ╔═╡ f4df6d7e-8ecc-4cb5-a878-cf3e14fbf6c8
B1

# ╔═╡ a736777e-a21a-4a78-8edf-addc3fc131fa
Random walk

# ╔═╡ f4d18e96-904c-4742-9349-a42c3a76cde8
begin
	"""
	generate n random walks from 0 to T with N steps
	Returns:
	   t (range) of time from 0 to T with N steps
	   W (nxN array) of random walks
	"""
	function rwalks(T,N,n)
	    dt = T/N
	    dW = sqrt(dt)*randn(n,N)
	    W = zeros(n,N)
	    W[:,1] = dW[:,1]
	    for j = 2:N
	        W[:,j] .= W[:,j-1] .+ dW[:,j]
	    end
	    0:dt:T-dt, W
	end
end

# ╔═╡ 933ad654-1ddf-4f80-af60-be82de10ff62
# generate random walk
t,W = rwalks(1,1000,10)

# ╔═╡ eb11a282-0ea9-4235-9505-e3d56f97abcf
begin
	# convert random walk into DataFrames for plotting using Gadfly
	using DataFrames
	walk = convert(DataFrame, W')
	dataname = names(walk) # [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9, :x10]
	walk[:t] = Array(t)
	longform = stack(walk, dataname) # Gadfly prefer long form
	
	# plot action
	using Gadfly
	plot(longform, x=:t, y=:value, color=:variable, Geom.line, Guide.xlabel("t"), Guide.ylabel("W(t)"), Guide.title("random walk"))
	
	#=
	DataFrams doc: <https://juliadata.github.io/DataFrames.jl/stable/index.html>
	Gadfly doc: <http://gadflyjl.org/stable/index.html>
	=#
end

# ╔═╡ 2bc06d73-cad4-4a5e-a541-873980971046
md"""
Wie viele Fälle sollen gezogen werden?
"""

# ╔═╡ 3f3675e7-6463-4c43-9bee-c985f78bacf8
@bind n2 Slider(0:10, default=2)

# ╔═╡ 6d6bd548-7ea0-4238-b549-c9dd3416965b
td = truncated(d, m-5sd, m+5sd)

# ╔═╡ 6bd524ba-54ed-4af2-9ab1-b2cd15e42b9d
rand(td, n)'

# ╔═╡ 0bdea5d9-9af5-48c9-af10-9bb43935dc4d


# ╔═╡ 6ca2f007-e319-4ac1-8d2d-b5dfbc4552d0
md"""
Fläche unter einer Normalverteilung 
"""

# ╔═╡ 7d1c2280-e7b1-4dd0-8731-8f3a2e9978a9
@bind z Slider(0:0.25:3, default=1)

# ╔═╡ 92200bed-03c3-4959-b526-31a80ad418a2


# ╔═╡ b981d3ab-7cd6-464b-bdfc-559f57f16da0


# ╔═╡ b27b4d6a-447f-4df6-b760-e274c95702be
import PlutoUI: combine

# ╔═╡ 9438ad41-5177-4927-b86a-952e1df0bba4
function wind_speed_input(directions::Vector)
	
	return combine() do Child
		
		inputs = [
			md""" $(name): $(
				Child(name, Slider(1:100))
			)"""
			
			for name in directions
		]
		
		md"""
		#### Wind speeds
		$(inputs)
		"""
	end
end

# ╔═╡ 2f3c0312-e899-4b6f-ba9d-2c4136e7e6fc
@bind speeds wind_speed_input(["mean", "sd", "alpha-", "alpha+"])

# ╔═╡ 956ab8df-bb77-4a31-b023-f86724098462
md"""
Der Mittelwert der Verteilung ist $(@bind m2 Scrubbable(50:1:150, default=100)) und die Standardabweichung $(@bind sd2 Scrubbable(5:1:20)). Das untere alpha ist $(@bind a1 Scrubbable(0.00:0.05:0.5, default=0.025, format=".3")), das obere $(@bind a2 Scrubbable(0.5:0.05:1, default=0.975, format=".3")),
"""

# ╔═╡ 6a06ee9b-4c80-4a49-b616-2fb3ebac9e6d
function npdensity(z,inferior,superior)

    n = size(z,2)
    p = zeros(n)
    for i = 1:n
        x = z[:,i]
        y = kde(x)
        q05 = quantile(x,0.05)
        Plots.plot(range(minimum(x), stop=inferior, length=100),z->pdf(y,z), color=:red, fill=(0,0.5,:red), label="-Zc")
        q95 = quantile(x,0.95)
        Plots.plot!(range(inferior, stop=superior, length=100),z->pdf(y,z), color=:green, fill=(0,0.5,:green),label="Região de Aceitação")
        Plots.plot!(range(superior, stop=maximum(x), length=100),z->pdf(y,z), color = :red, fill=(0,0.5,:red),label="Zc")
        m = mean(x)
        Plots.plot!([m,m],[0,pdf(y,m)],color=:blue, label="média")
        m = median(x)
        if i == 1
            p = Plots.plot!([m,m],[0,pdf(y,m)],color=:black, label="mediana")
        else
            p = [p, Plots.plot!([m,m],[0,pdf(y,m)],color=:black, label="mediana")]
        end
    end
    return p
end

# ╔═╡ ac401b45-456d-4f7e-8c36-58f32086f38e
parafusos = rand( Normal( 0 , 1 ),1000000)

# ╔═╡ 3c03c053-02b2-42dc-8a5c-01114588ad13
npdensity(parafusos,-1.96,1.96)

# ╔═╡ 250cdbc4-bb19-4d93-a8c6-f689511b7974


# ╔═╡ 02a1698a-2a4e-4e13-af4f-f3311d819559


# ╔═╡ 08cb206d-cbb1-497c-a8a5-705dbc5bb05c
@bind fruit Select(["apple" => "🍎", "melon" => "🍉"])

# ╔═╡ Cell order:
# ╠═a61e79d0-b44d-11ed-0f75-c3c2abe12679
# ╠═0f455005-3900-4feb-9464-47a092e5a9dd
# ╠═092f10fb-38c6-4a2c-baad-e542191495df
# ╠═521c8a2d-71e6-4b3c-84f4-8295815196c2
# ╠═b5eff4c2-e59d-4712-84cd-02ad17681477
# ╠═6d5312c6-88a1-4c52-8e01-19fb7d0be82a
# ╠═637ee94b-6f99-4940-b628-3e7593c00226
# ╠═978f7bd6-bfb0-4dd7-a2ce-dfe7c76d43a4
# ╠═6f2f1b70-0e2c-499b-b6ee-d02012fac06f
# ╠═27ba5d8b-2021-4f2a-af58-ebfa9e55b357
# ╠═f4df6d7e-8ecc-4cb5-a878-cf3e14fbf6c8
# ╠═a736777e-a21a-4a78-8edf-addc3fc131fa
# ╠═f4d18e96-904c-4742-9349-a42c3a76cde8
# ╠═933ad654-1ddf-4f80-af60-be82de10ff62
# ╠═eb11a282-0ea9-4235-9505-e3d56f97abcf
# ╠═2bc06d73-cad4-4a5e-a541-873980971046
# ╠═3f3675e7-6463-4c43-9bee-c985f78bacf8
# ╠═6d6bd548-7ea0-4238-b549-c9dd3416965b
# ╠═6bd524ba-54ed-4af2-9ab1-b2cd15e42b9d
# ╠═0bdea5d9-9af5-48c9-af10-9bb43935dc4d
# ╟─6ca2f007-e319-4ac1-8d2d-b5dfbc4552d0
# ╠═7d1c2280-e7b1-4dd0-8731-8f3a2e9978a9
# ╠═a5d75065-83c6-4ae9-aab5-d275e9b1e50a
# ╠═92200bed-03c3-4959-b526-31a80ad418a2
# ╠═b981d3ab-7cd6-464b-bdfc-559f57f16da0
# ╠═7aad9fe9-6e20-4116-9c06-279f6794370d
# ╠═b27b4d6a-447f-4df6-b760-e274c95702be
# ╠═9438ad41-5177-4927-b86a-952e1df0bba4
# ╠═2f3c0312-e899-4b6f-ba9d-2c4136e7e6fc
# ╠═956ab8df-bb77-4a31-b023-f86724098462
# ╠═6a06ee9b-4c80-4a49-b616-2fb3ebac9e6d
# ╟─ac401b45-456d-4f7e-8c36-58f32086f38e
# ╠═3c03c053-02b2-42dc-8a5c-01114588ad13
# ╠═250cdbc4-bb19-4d93-a8c6-f689511b7974
# ╠═02a1698a-2a4e-4e13-af4f-f3311d819559
# ╠═08cb206d-cbb1-497c-a8a5-705dbc5bb05c
