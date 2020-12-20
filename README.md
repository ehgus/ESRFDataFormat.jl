# ESRFDataFormat.jl

implemenation of ESRF data format (.edf) based on [Keywords for SAXS Data in EDF files](http://www.esrf.eu/files/live/sites/www/files/UsersAndScience/Experiments/SoftMatter/ID02/Software/SaxsKeywords.pdf)

## Usage

```julia
using ESRFDataFormat

io = open("target.edf")
esrfdata = read(io,ESRFData)
```

## development note

### implementation hypothesis

- file to be read has no defect or ignorable defect
- file to be written by this package should follows ESRF Data Format rigorously

### todo

- write implementation with validation checker
- read/write compressed file