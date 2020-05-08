module RunLengthCodec

import Base.Iterators: cycle
"""
Take some iterable of symbols and produce a vector `[(symbol, count), ...]`
"""
function encode(input)
    output = Tuple{eltype(input), Int}[]
    for e in input
        if length(output) == 0
            push!(output, (e, 1))
            continue
        end

        if isequal(output[end][1], e)
            # TODO use a Lens package (setfield?)
            output[end] = (e, output[end][2] + 1)
        else
            push!(output, (e, 1))
        end
    end
    return output
end


function decode(input)
  T#=::Type{Tuple}=# = eltype(input)
  (output_eltype, count_type) = Tuple(T.parameters)
  output_n = sum(last.(input))
  output = Array{output_eltype}(undef, output_n)

  decode!(output, input)
  return output
end


function decode!(output, input)
  i = 1
  for (v, c) in input
    j = i + c
    output[i:(j-1)] .= Ref(v)
    i = j
  end
  return output
end



"""
A of `true`/`false` values, when RLE'd, alternates between true/false.
So it is enough to just encode the counts, provided we always start on `false`,
which is guaranteed by adding a count of `0` when necessary.
"""
function bool_normalize(rle)
    # ensure we start on `false`
    prefix = if first(first(rle))
        [0]
    else
        Int[]
    end
    return vcat(prefix, last.(rle))
end

inv_bool_normalize(input) = zip(cycle((false, true)), input)

bool_encode(input) = bool_normalize(encode(input))

function bool_decode(input)
  decode(inv_bool_normalize(input))
end

end
