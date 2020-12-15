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
        # Error later
    end
    
    contents = start*readuntil(io,format.End;keep=true)
    if contents[begin:length(format.Start)] != format.Start || contents[end+1-length(format.Start):end] != format.End
        # Error later
    end
    
    header = Dict(KeyValseperation.(split(contents[length(format.Start)+1:end-length(format.End)],';')[begin:end-1]))
    # Array reading
    if isa(match(r"^Float(Value|IEEE32)?$",header["DataType"]),RegexMatch)
        Arraytype = Float32 
    elseif isa(match(r"^(FloatIEEE64|Double(Value)?)$",header["DataType"]),RegexMatch)
        Arraytype = Float64
    elseif isa(match(r"^Signed64$",header["DataType"]),RegexMatch)
        Arraytype = Int64
    else
        # type currently unused maybe
        @assert false
    end

    # 2 dim for now (tmp)
    data = Array{Arraytype,2}(undef,header["Dim_1"],header["Dim_2"])
    read!(io,data)
    if !eof(io)
        print("Waring This is not eof")
    end
    map!(bswaptoh(header),data,data)
    
    ESRFData(header, data)
end