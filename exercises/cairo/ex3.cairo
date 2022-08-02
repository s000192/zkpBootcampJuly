## I AM NOT DONE

## Perform and log output of simple arithmetic operations
func simple_math():
    
    ## adding 13 +  14
    let x = 13 + 14
    %{ print(ids.x) %}

    ## multiplying 3 * 6
    let y = 3 * 6
    %{ print(ids.y) %}

    ## dividing 6 by 2
    let z = 6 / 2
    %{ print(ids.z) %}

    ## dividing 70 by 2
    let a = 70 / 2
    %{ print(ids.a) %}

    ## dividing 7 by 2 
    let b = 7 / 2
    %{ print(ids.b) %}

    return ()
end