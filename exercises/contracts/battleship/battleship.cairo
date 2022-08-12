## I AM NOT DONE

%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_le, uint256_unsigned_div_rem, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt, assert_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash_state import hash_init, hash_update 
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor

struct Square:    
    member square_commit: felt
    member square_reveal: felt
    member shot: felt
end

struct Player:    
    member address: felt
    member points: felt
    member revealed: felt
end

struct Game:        
    member player1: Player
    member player2: Player
    member next_player: felt
    member last_move: (felt, felt)
    member winner: felt
end

@storage_var
func grid(game_idx : felt, player : felt, x : felt, y : felt) -> (square : Square):
end

@storage_var
func games(game_idx : felt) -> (game_struct : Game):
end

@storage_var
func game_counter() -> (game_counter : felt):
end

func hash_numb{pedersen_ptr : HashBuiltin*}(numb : felt) -> (hash : felt):

    alloc_locals
    
    let (local array : felt*) = alloc()
    assert array[0] = numb
    assert array[1] = 1
    let (hash_state_ptr) = hash_init()
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(hash_state_ptr, array, 2)   
    tempvar pedersen_ptr :HashBuiltin* = pedersen_ptr       
    return (hash_state_ptr.current_hash)
end


## Provide two addresses
@external
func set_up_game{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(player1 : felt, player2 : felt):
    let (gc) = game_counter.read()

    games.write(
        gc,
        Game(
            player1=Player(player1, 0, 0),
            player2=Player(player2, 0, 0),
            next_player=0,
            last_move=(0,0),
            winner=0,
        )
    )

    let new_game_idx = gc + 1
    game_counter.write(new_game_idx)

    return ()
end

@view 
func check_caller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(caller : felt, game : Game) -> (valid : felt):
    if (caller - game.player1.address) * (caller - game.player2.address) == 0:
        return (1)
    end

    return(0)  
end

@view
func check_hit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(square_commit : felt, square_reveal : felt) -> (hit : felt):
    let (hashed) = hash_numb(square_reveal)
    let (q, r) = unsigned_div_rem(square_reveal, 2)
    if hashed - square_commit + r - 1 == 0:
        return (1)
    end

    return(0)
end

@external
func bombard{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(game_idx : felt, x : felt, y : felt, square_reveal : felt):
    return ()
end



## Check malicious call
@external
func add_squares{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(idx : felt, game_idx : felt, hashes_len : felt, hashes : felt*, player : felt, x: felt, y: felt):
    let (caller) = get_caller_address()
    let (game) = games.read(game_idx)
    let (is_caller_valid) = check_caller(caller, game)
    assert is_caller_valid = 1

    load_hashes(idx, game_idx, hashes_len, hashes, player, x, y)
    return ()
end

## loops until array length
func load_hashes{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(idx : felt, game_idx : felt, hashes_len : felt, hashes : felt*, player : felt, x: felt, y: felt):
    if hashes_len == 0:
        return ()
    end

    ## TODO: load hash
    grid.write(
        game_idx=game_idx,
        player=player,
        x=x,
        y=y,
        value=Square(
            square_commit=[hashes],
            square_reveal=0,
            shot=0
        )
    )

    if x == 4:
        load_hashes(idx, game_idx, hashes_len - 1, hashes + 1, player, 0, y + 1)
    else:
        load_hashes(idx, game_idx, hashes_len - 1, hashes + 1, player, x + 1, 0)
    end
    return ()
end
