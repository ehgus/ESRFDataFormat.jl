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

    if isa(match(r"^Float(Value|IEEE32)?$",typestr),RegexMatch)
        return Float32 
    elseif isa(match(r"^(FloatIEEE64|Double(Value)?)$",typestr),RegexMatch)
        return Float64
    elseif isa(match(r"^Signed(8|Byte)$",typestr),RegexMatch)
        return Int8
    elseif isa(match(r"^Unsigned(8|Byte)$",typestr),RegexMatch)
        return UInt8
    elseif isa(match(r"^Signed(16|Short)$",typestr),RegexMatch)
        return Int16
    elseif isa(match(r"^Unsigned(8|Short)$",typestr),RegexMatch)
        return UInt16
    elseif isa(match(r"^Signed(32|Integer|Long)$",typestr),RegexMatch)
        return Int32
    elseif isa(match(r"^Unsigned(32|Integer|Long)$",typestr),RegexMatch)
        return UInt32
    elseif isa(match(r"^Signed64$",typestr),RegexMatch)
        return Int64
    elseif isa(match(r"^Unsigned64$",typestr),RegexMatch)
        return UInt64
    else
        error("Your header requires unsupported data type $(typestr)")
    end
end

"""
see header["Compression"] and check its compression type
"""
function datacompressstream(io::IO,header::Dict)
    if "Compression" in keys(header)
        compstr::String = header["Compression"]
    else
        return io
    end

    if isa(match(r"^(None|UnCompressed|NoSpecificValue)$",compstr),RegexMatch)
        return io
    elseif isa(match(r"^Gzip(Compression)?$",compstr),RegexMatch)
        return GzipDecompressorStream(io)
    elseif isa(match(r"^Z(Compression)?$",compstr),RegexMatch)
        return ZlibDecompressorStream(io)
    else
        error("unsuppoed compression : $(compstr)")
    end
end

function datasize(header::Dict)
    keyset::Array{String,1} =[]
    for key in keys(header)
        if isa(match(r"^Dim_\d+$",key),RegexMatch)
            push!(keyset,key)
        end
    end
    if Set(["Dim_$(i)" for i in 1:length(keyset)]) != Set(keyset)
        error("dimension metatdata of array is missing or corrupted: $(keyset)")
    end
    return [header["Dim_$(i)"] for i in 1:length(keyset)]
end
            


function KeyValseperation(KeyValStr::T) where T <: AbstractString
    #consider using eachmatch
    (Key, Val) = strip.(split(KeyValStr,'='))
    if isa(match(r"^[+-]?\d+$",Val),RegexMatch)
        # Integer
        Valreturn = parse(Int128,Val)
    elseif isa(match(r"^[+-]?(\d*[.])?\d+$",Val),RegexMatch)
        # Float
        Valreturn = parse(Float64,Val)
    elseif isa(match(r"^(19|20)\d\d-(0\d|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-4]):[0-5]\d:[0-5]\d$",Val),RegexMatch)
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
