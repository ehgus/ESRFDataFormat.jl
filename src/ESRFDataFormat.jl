module ESRFDataFormat

using CodecZlib, Dates

export ESRFData
export read,
       header,
       data

include("ESRFData.jl")
include("io.jl")
include("utils.jl")

end # module
