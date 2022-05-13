using DifferentialEquations,Plots

function rober!(du,u,p,t)
    y1,y2,y3 = u
    k1,k2,k3 = p
    du[1] = -k1*y1 + k3*y2*y3
    du[2] = k1*y1 - k3*y2*y3 - k2*y2^2
    du[3] = k2*y2^2
    nothing
end

u = [1.0,0.0,0.0]
tspan = (0.0,1e5)
params = [0.04,3e7,1e4]

ode_prob = ODEProblem(rober!,u,tspan,params)

ode_sol = solve(ode_prob)
plot(ode_sol,tspan=(1e-6,1e5),xscale=:log10,layout=(3,1))