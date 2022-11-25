#!/bin/bash

# https://stackoverflow.com/questions/10415064/how-to-calculate-the-minimum-of-two-variables-simply-in-bash
min_n() {
    printf "%s\n" "$@" | sort -g | head -n1
}
max_n() {
    printf "%s\n" "$@" | sort -r | head -n1
}

i=0

for w in 1 2 4 7 15 25 26
do
    for k in 1 2 4 7 15 25 26
    do
        mkdir -p "wyniki/${w}x${k}"
        for x in {1..3}
        do
            python3 gen.py $w $k > "wyniki/${w}x${k}/${x}.in"
            min_tab="$(min_n $w $k)"
            div=$(echo "$min_tab / $x" | bc)
            dl="$(max_n $div 1)"
            echo "generowanie -DWIERSZE=${w} -DKOLUMNY=${k} -DDLUGOSC=${dl}"
            gcc @opcje -DWIERSZE=${w} -DKOLUMNY=${k} -DDLUGOSC=${dl} main.c -o main
            cat "wyniki/${w}x${k}/${x}.in" | valgrind --leak-check=full -q --error-exitcode=1 ./main > "wyniki/${w}x${k}/${x}.out"
            if [[ "$?" -ne 0 ]] ; then
                exit 1
            fi
            ((i++))
        done
    done
done

echo -e "\033[0;32m$i testow OK"
