using ESRFDataFormat


const HeaderPattern = (
    Standard = (Start = "{\n", End = "}\n"),
    Alternative1 = (Start = "\n{\r\n", End = "}\n"),
    Alternative2 = (Start = "\r\n{\r\n", End = "}\r\n")
)

function Base.read(io::IO,::Type{T}) where T<: ESRFData
    start = read(io,Char)
    if start == '{'
        # Standard
        format = HeaderPattern.Standard
    elseif start == '\n'
        # Alternative1
        format = HeaderPattern.Alternative1
    elseif start == '\r'
        # Alternative2
        format = HeaderPattern.Alternative2
    else
        error("Disallowed header")
    end
    
    contents = start*readuntil(io,format.End;keep=true)
    if contents[begin:length(format.Start)] != format.Start || contents[end+1-length(format.Start):end] != format.End
        error("Disallowed header")
    end
    
    header = Dict(KeyValseperation.(split(contents[length(format.Start)+1:end-length(format.End)],';')[begin:end-1]))
    # Array metadata
    dtype = datatype(header)
    dsize = datasize(header)
    data = Array{dtype}(undef,dsize...)
    newio = dataDecompressstream(io,header)
    read!(newio,data)
    if !eof(newio)
        println("Waring: This is not eof")
    end
    map!(bswaptoh(header),data,data)
    
    ESRFData(header, data)
end