## I AM NOT DONE

%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

## Using binary operations return: 
## - 1 when pattern of bits is 01010101 from LSB up to MSB 1, but accounts for trailing zeros
## - 0 otherwise

## 000000101010101 PASS
## 010101010101011 FAIL

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(n: felt, idx: felt, exp: felt, broken_chain: felt) -> (true : felt):
    let (right_shift_num, remainder) = unsigned_div_rem(n, 2)
        
    let (x_and_y) = bitwise_and(n, right_shift_num)
    if x_and_y == 0:
        let (x_xor_y) = bitwise_xor(n, right_shift_num)
        let (result) = bitwise_and(x_xor_y, x_xor_y + 1)

        if result == 0:
            return(1)
        else:
            return(0)
        end
    else:
        return(0)
    end
end






