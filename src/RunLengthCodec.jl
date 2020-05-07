module RunLengthCodec

import Transducers: Transducers, Transducer, R_, wrap, start, Unseen, inner

struct RunLengthEncode{T} <: Transducer
end

function Transducers.start(rf::R_{RunLengthEncode}, result)
  private_state = (0, Transducers.Unseen())
  return wrap(rf, private_state, start(inner(rf), result))
end

function Transducers.next(rf::R_{RunLengthEncode}, result, input)
  wrapping(rf, result) do st, iresult
    (count, symbol) = st
    if count == 0
      symbol = input
    end
    if symbol == input
      count += 1
      return (count, symb)
    else
      emit = (count, symbol)
      count = 1
      symbol = input

    end
  end
end


struct Dedupe <: Transducer
end

start(rf::R_{Dedupe}, result) = wrap(rf, Unseen(), start(inner(rf), result))
complete(rf::R_{Dedupe}, result) = complete(inner(rf), unwrap(rf, result)[2])

function next(rf::R_{Dedupe}, result, input)
    @show rf
    wrapping(rf, result) do prev, iresult
        if prev isa Unseen || prev != input
            return input, next(inner(rf), iresult, input)
        else
            return input, iresult
        end
    end
end

end
