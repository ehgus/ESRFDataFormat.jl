
function KeyValseperation(KeyValStr::T) where T <: AbstractString
    #consider using eachmatch
    (Key, Val) = strip.(split(KeyValStr,'='))
    if isa(match(r"^[+-]?\d+$",Val),RegexMatch) # Integer
        Valreturn = parse(Int128,Val)
    elseif isa(match(r"^[+-]?(\d*[.])?\d+$",Val),RegexMatch) # Float
        Valreturn = parse(Float64,Val)
    else
        Valreturn = Val
    end

    Key, Valreturn
end

function bswaptoh(header::Dict)
    ifelse("ByteOrder" in keys(header) && header["ByteOrder"] == "LowByteFirst", ltoh, ntoh)
end
