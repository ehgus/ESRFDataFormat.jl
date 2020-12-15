

mutable struct ESRFData 
    header::AbstractDict
    data::AbstractArray
end

@inline header(d::ESRFData) = d.header

@inline data(d::ESRFData) = d.data