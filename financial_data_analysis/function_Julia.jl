# this file we are trying multiple dispath

# 1. this is to show how Julia works with different types of data in "+" operation
@which 1 + 1
@which 1.0 + 1.0
@which 1 + 1.0

# here is some examples for multiple dispath for user-defined function
function methodtest(x,y)
    println("This is the default method for $x and $y.")
end

function methodtest(x::Integer, y::Integer)
    println("$x plus $y equals ", x+y)
end

methodtest(1,2)
methodtest(1.1,1.2)

function methodtest(x::AbstractFloat,y::AbstractFloat)
    println("$x times $y equals ",x*y)
end

methodtest(1.1,2.2)

function methodtest(x::String,y::String)
    println("""Concetenating $x and $y yields "$x $y"  """)
end

methodtest("Hello","World")
methodtest("David",1.2)

methods(methodtest)

@which methodtest("Hello","World")


# composite types
struct  MyType
    x
    y::Integer
    z::AbstractFloat
end

typeof(MyType)

mt = MyType("doggo",1,3.14)

typeof(mt)

fieldnames(MyType)

mt.x
mt.y

mt.x = "Richard"

mutable struct MyMutable
    x
    y::Integer
    z::AbstractFloat
end

mm = MyMutable("Catto",2,π)

mm.x
mm.x = "Richard"
mm.x

using Plots
theme(:ggplot2)
x = range(-2π,2π,length=200)
y = sin.(x)
plot(x,y,label="y = sin(x)")
y2 = cos.(x)
plot!(x,y2,label="y2 = cos(x)")
plot!(title="Sine and Cosine Plots")
savefig("sine_and_cos_plot.png")

# another way of plotting
plot(x,
     y,
     xlabel = "x range",
     ylabel = "sin(x)",
     title = " y = sin(x) ",
     label = false,
     color = :blue,
     linewidth = 3.5,
     linestyle =:dashdot  
)
plot!(x,
      y2,
      label = false,
      color =:orange,
      linewidth = 4,
      linestyle =:dash
)
savefig("another_plot.png")

plot(x -> sin(x),
     xlims =(0,2π),
     ylims = (-1.05,1.05),
     xticks = ((0:π/2:2π),["0","π/2","π","3π/2","2π"]),
     tickfontsize = 10,
     linewidth = 4,
     linecolor = :black;
     label = "sin(x)")
plot!(y -> cos(y),
      linewidth = 4,
      linestyle = :dashdot,
      color =:blue,
     label = "cos(y)")
savefig("plot3.png")

# try subplot here
x = range(-2π,2π,length=200);
y1 = 2*cos.(x) .+ 5;
p1 = plot(x,
          y1,
          linewidth = 3,
          linecolor = :blue,
          label = "y = 2cos(x)+5");
y2 = 3*sin.(x) .- 2;
p2 = plot(x,
          y2,
          linewidth = 3,
          linecolor =:black,
          label = "y = 2sin(x)-2");
plot(p1,p2,layout=(2,1))