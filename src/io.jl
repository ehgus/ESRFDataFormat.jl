using ESRFDataFormat


function Base.read(io::IO,::Type{ESRFData})
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
    if isnothing(match(Regex("$(format.End)"),contents))
        error("Disallowed header")
    end
    startline = match(Regex("^$(format.Start)(EDF_DataFormatVersion)?"),contents)
    if isnothing(startline)
        error("Disallowed header")
    elseif isnothing(startline[1])
        # DataBlock
        header = Dict(KeyValseperation.(split(contents[length(format.Start)+1:end-length(format.End)],';')[begin:end-1]))
        # Array metadata
        dtype = datatype(header)
        dsize = datasize(header)
        data = Array{dtype}(undef,dsize...)
        newio = dataDecompressstream(io,header)
        read!(newio,data)
        map!(bswaptoh(header), data, data)
        return ESRFDataBlock(header, data)
    else
        # GeneralBlock
        header = Dict(KeyValseperation.(split(contents[length(format.Start)+1:end-length(format.End)],';')[begin:end-1]))
        return ESRFGeneralBlock(header, [read(io, ESRFData) for _ in header["EDF_DataBlocks"]])
    end
end
