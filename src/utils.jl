using ESRFDataFormat

"""
convert header["DataType"] into appropriate type
"""
function datatype(header::Dict)
    if "DataType" in keys(header)
        typestr::String = header["DataType"]
    else
        error("header does not contain DataType information")
    end

    if !isnothing(match(r"^Float(Value|IEEE32)?$", typestr))
        return Float32
    elseif !isnothing(match(r"^(FloatIEEE64|Double(Value)?)$", typestr))
        return Float64
    elseif !isnothing(match(r"^Signed(8|Byte)$", typestr))
        return Int8
    elseif !isnothing(match(r"^Unsigned(8|Byte)$", typestr))
        return UInt8
    elseif !isnothing(match(r"^Signed(16|Short)$", typestr))
        return Int16
    elseif !isnothing(match(r"^Unsigned(16|Short)$", typestr))
        return UInt16
    elseif !isnothing(match(r"^Signed(32|Integer|Long)$", typestr))
        return Int32
    elseif !isnothing(match(r"^Unsigned(32|Integer|Long)$", typestr))
        return UInt32
    elseif !isnothing(match(r"^Signed64$", typestr))
        return Int64
    elseif !isnothing(match(r"^Unsigned64$", typestr))
        return UInt64
    else
        error("Your header requires unsupported data type $(typestr)")
    end
end

"""
see header["Compression"] and check its compression type
"""
function dataDecompressstream(io::IO,header::Dict)
    if "Compression" in keys(header)
        compstr::String = header["Compression"]
    else
        return io
    end

    if !isnothing(match(r"^(None|UnCompressed|NoSpecificValue)$",compstr))
        return io
    elseif !isnothing(match(r"^Gzip(Compression)?$",compstr))
        return GzipDecompressorStream(io)
    elseif !isnothing(match(r"^Z(Compression)?$",compstr))
        return ZlibDecompressorStream(io)
    else
        error("unsuppoed compression : $(compstr)")
    end
end

function datasize(header::Dict)
    keyset::Array{String,1} =[]
    for key in keys(header)
        if !isnothing(match(r"^Dim_\d+$",key))
            push!(keyset,key)
        end
    end
    if Set(["Dim_$(i)" for i in 1:length(keyset)]) != Set(keyset)
        error("dimension metatdata of array is missing or corrupted: $(keyset)")
    end
    
    [header["Dim_$(i)"] for i in 1:length(keyset)]
end
            


function KeyValseperation(KeyValStr::T) where T <: AbstractString
    #consider using eachmatch
    (Key, Val) = strip.(split(KeyValStr,'='))
    if !isnothing(match(r"^[+-]?\d+$",Val))
        # Integer
        Valreturn = parse(Int128,Val)
    elseif !isnothing(match(r"^[+-]?(\d*[.])?\d+$",Val))
        # Float
        Valreturn = parse(Float64,Val)
    elseif !isnothing(match(r"^(19|20)\d\d-(0\d|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-4]):[0-5]\d:[0-5]\d$",Val))
        # Date
        Valreturn = Date(Val,"YYYY-mm-dd HH:MM:SS") # Note: julia Date cannot represent nanosecond
    else
        Valreturn = Val
    end

    Key, Valreturn
end

function bswaptoh(header::Dict)
    ifelse("ByteOrder" in keys(header) && header["ByteOrder"] == "LowByteFirst", ltoh, ntoh)
end
