@testset "datatype" begin
    @test datatype(Dict("DataType" => "FloatValue")) == Float32
    @test datatype(Dict("DataType" => "FloatIEEE32")) == Float32

    @test datatype(Dict("DataType" => "FloatIEEE64")) == Float64
    @test datatype(Dict("DataType" => "Double")) == Float64
    @test datatype(Dict("DataType" => "DoubleValue")) == Float64

    @test datatype(Dict("DataType" => "Signed8")) == Int8
    @test datatype(Dict("DataType" => "SignedByte")) == Int8
    @test datatype(Dict("DataType" => "Unsigned8")) == UInt8
    @test datatype(Dict("DataType" => "UnsignedByte")) == UInt8

    @test datatype(Dict("DataType" => "Signed16")) == Int16
    @test datatype(Dict("DataType" => "SignedShort")) == Int16
    @test datatype(Dict("DataType" => "Unsigned16")) == UInt16
    @test datatype(Dict("DataType" => "UnsignedShort")) == UInt16

    @test datatype(Dict("DataType" => "Signed32")) == Int32
    @test datatype(Dict("DataType" => "SignedInteger")) == Int32
    @test datatype(Dict("DataType" => "SignedLong")) == Int32
    @test datatype(Dict("DataType" => "Unsigned32")) == UInt32
    @test datatype(Dict("DataType" => "UnsignedInteger")) == UInt32
    @test datatype(Dict("DataType" => "UnsignedLong")) == UInt32

    @test datatype(Dict("DataType" => "Signed64")) == Int64
    @test datatype(Dict("DataType" => "Unsigned64")) == UInt64
end