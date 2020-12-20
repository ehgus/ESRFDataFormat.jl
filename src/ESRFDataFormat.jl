module ESRFDataFormat

using CodecZlib, Dates

export ESRFData
export read,
       header,
       data

const HeaderPattern = (
    Standard = (Start = "{\n", End = "}\n"),
    Alternative1 = (Start = "\n{\r\n", End = "}\n"),
    Alternative2 = (Start = "\r\n{\r\n", End = "}\r\n")
)
include("ESRFData.jl")
include("io.jl")
include("utils.jl")

end # module
