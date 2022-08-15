## I AM NOT DONE

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

## Implement a function that sums even numbers from the provided array 
func sum_even{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(arr_len : felt, arr : felt*, run : felt, idx : felt) -> (sum : felt):
    alloc_locals
    if arr_len == 0:
        return(0)
    end

    let (q, r) = unsigned_div_rem([arr], 2)
    let (sum_of_rest) = sum_even(arr_len - 1, arr + 1, run, idx)
    if r != 0:
        return(sum_of_rest)
    else:
        return([arr] + sum_of_rest)
    end
end
