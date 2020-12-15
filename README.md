# ESRFDataFormat.jl

implemenation of ESRF data format (.edf) based on [Keywords for SAXS Data in EDF files](http://www.esrf.eu/files/live/sites/www/files/UsersAndScience/Experiments/SoftMatter/ID02/Software/SaxsKeywords.pdf)

## Usage

```julia
io = open("target.edf")
esrfdata = read(io,ESRFData)
```

## todo

- inline implementation (with performance test)
- write implementation
- validation checker
