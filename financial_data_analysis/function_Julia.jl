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