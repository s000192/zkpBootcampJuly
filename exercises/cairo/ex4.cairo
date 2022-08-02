## I AM NOT DONE

## Return summation of every number below and up to including n
func calculate_sum(n : felt) -> (sum : felt): 
    if n == 0:
        return(sum = 0)
    end

    let (sum_of_rest) = calculate_sum(n - 1)
    return(sum=n + sum_of_rest)
end

