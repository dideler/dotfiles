function char-index -d "Prints character indexes of the given strings"
    set --local argc (count $argv)

    for arg_i in (seq $argc)
        set --local chars (string split '' $argv[$arg_i])
        for i in (seq (count $chars))
            echo $i: $chars[$i]
        end

        test $arg_i -lt $argc
        and echo
    end
end
