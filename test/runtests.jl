using RunLengthCodec: encode, decode, bool_encode, bool_decode
using Test

@testset "RunLengthCodec.jl" begin
  @test 0 == length(encode([]))
  @test [(0, 2), (1, 1), (0, 3)] == encode([0,0,1,0,0,0])
end

@testset "all bytes" begin
  for x = collect(Iterators.product(ntuple(_->(false, true), 8)...))
    @test collect(x) == bool_decode(bool_encode(x))
  end
end
