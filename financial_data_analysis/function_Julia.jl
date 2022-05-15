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

using CarioMakie

x = range(0, 10, length=100)
y = sin.(x)
lines(x,y)

scatter(x,y)

x = range(0,2π,length=100)
lines(x,cos)
lines!(x,sin)
current_figure()

