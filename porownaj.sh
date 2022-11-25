#!/bin/bash

# https://stackoverflow.com/questions/10415064/how-to-calculate-the-minimum-of-two-variables-simply-in-bash
min_n() {
    printf "%s\n" "$@" | sort -g | head -n1
}
max_n() {
    printf "%s\n" "$@" | sort -r | head -n1
}

i=0
code=$(ls *.c | head -1)
[ -z $code ] && echo "brakuje pliku .c w $PWD" && exit 1

for w in 1 2 4 7 15 25 26
do
    for k in 1 2 4 7 15 25 26
    do
        mkdir -p "wyniki/${w}x${k}"
        for x in {1..3}
        do
            min_tab="$(min_n $w $k)"
            div=$(echo "$min_tab / $x" | bc)
            dl="$(max_n $div 1)"
            echo "testowanie: -DWIERSZE=${w} -DKOLUMNY=${k} -DDLUGOSC=${dl}"
            gcc @opcje -DWIERSZE=${w} -DKOLUMNY=${k} -DDLUGOSC=${dl} $code -o main
            cat "wyniki/${w}x${k}/${x}.in" | valgrind --leak-check=full -q --error-exitcode=1 ./main > "wyniki/${w}x${k}/${x}.1.out"
            if [[ "$?" -ne 0 ]] ; then
                exit 1
            fi
            diff "wyniki/${w}x${k}/${x}.out" "wyniki/${w}x${k}/${x}.1.out"
            if [[ "$?" -ne 0 ]] ; then
                exit 1
            fi
            ((i++))
        done
    done
done
rm main 2> /dev/null

echo -e "\033[0;32m$i testow OK"
