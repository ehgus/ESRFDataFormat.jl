
const HeaderPattern = Dict(
    "standard" => ("{\r\n","}\n"),
    "alternative" => ("\n{\r\n\r\n{\r\n","}\n}\r\n")
)

function Base.read(io::IO,Type{T}) where T<: ESRFData
    start = readuntil(io,"{";keep=true)
    if start == "{"
        # standard pattern
    else
        # alternative patterns
    end

    headerstring=readuntil(io,"}\n";keep=true)
    @assert headerstring[end-1:end] == "}\n"
    
end