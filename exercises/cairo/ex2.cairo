## I AM NOT DONE

from starkware.cairo.common.uint256 import Uint256, uint256_add

## Modify both functions so that they increment
## supplied value and return it
func add_one(y : felt) -> (val : felt):
   alloc_locals
   local y = y + 1
   return (y) 
end

func add_one_U256{range_check_ptr}(y : Uint256) -> (val : Uint256):
   alloc_locals
   let (local y, _) = uint256_add(y, Uint256(1, 0))
   return (y) 
end

