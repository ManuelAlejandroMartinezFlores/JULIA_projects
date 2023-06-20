using GLMakie

function record_volume(sim, datafunc;
        name = "file.mp4",
        duration = 1,
        step = 0.1,
    )
    data = Observable(datafunc(sim))
    set_theme!(
        theme_dark(),
        resolution = (720, 720)
    )
    fig = volume(
        data,
        colorrange = (pi, 3pi),
        algorithm = :absorption 
    )
    t0 = sim_time(sim)
    t = t0 .+ 0:step:duration 

    prog = 0
    record(fig, name, t) do ti 
        sim_step!(sim, ti)
        data[] = datafunc(sim)
        if round(Int, (ti - t0) / duration * 100) > prog 
            prog = round(Int, (ti - t0) / duration * 100)
            print("#")
        end
    end 
    sim, fig
end

using WaterLily

function TGV(p=6, Re=100_000)
    L = 2^p 
    U = 1 
    ν = U * L / Re 
    function uλ(i, vx)
        x, y, z = @. (vx - 1.5) * pi / L 
        i == 1 && return - U * sin(x) * cos(y) * cos(z)
        i == 2 && return U * cos(x) * sin(y) * cos(z)
        return 0. 
    end
    Simulation(
        (L+2, L+2, L+2), zeros(3), L;
        U, uλ, ν
    )
end 

function omega_mag_data(sim)
    @inside sim.flow.σ[I] = WaterLily.ω_mag(I, sim.flow.u) * sim.L / sim.U
    @view sim.flow.σ[2:end-1, 2:end-1, 2:end-1]
end

sim, fig = record_volume(TGV(), omega_mag_data;
    name = "TGV.mp4",
    duration = 20,
    step = 0.025
);