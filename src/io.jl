
const HeaderPattern = (
    Standard = (Start = "{\n", End = "}\n"),
    Alternative1 = (Start = "\n{\r\n", End = "}\n"),
    Alternative2 = (Start = "\r\n{\r\n", End = "}\r\n")
)

function Base.read(io::IO,Type{T}) where T<: ESRFData
    start = read(io,Char)
    format::Tuple{String,String}
    if start == "{"
        # Standard
        format = HeaderPattern.Standard
    elseif start == "\n"
        # Alternative1
        format = HeaderPattern.Standard
    elseif start == "\r"
        # Alternative2
        format = HeaderPattern.Standard
    else
        # Error later
    end
    
    contents = start*readuntil(io,format[End];keep=true)
    if contents[begin:length(format[Start])] != format[Start] || contents[end+1-length(format[Start]:end)] != format[End]
        # Error later
    end
    
    split(contents[length(format[Start])+1:end-length(format[End])],';')

end