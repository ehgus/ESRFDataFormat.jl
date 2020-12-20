

abstract type ESRFData end

@inline header(d::T) where T<:ESRFData = d.header


"""
# General Block Header Keywords

(Optional) This is only defined in Version>=2.
The start pattern of a general header is `\n{\r\nEDF_DataFormatVersion`,and it can be used for identifying a general header.

<special keywords>
 - EDF_DataFormatVersion (Obligatory)
 - EDF_DataBlocks (Obligatory)
 - EDF_BlockBoundary (optional, default = 512 byte)
"""

mutable struct ESRFDataBlock <: ESRFData
    header::AbstractDict
    data::AbstractArray
end

mutable struct ESRFGeneralBlock <: ESRFData
    header::AbstractDict
    datablocks::AbstractVector{ESRFDataBlock}
end
