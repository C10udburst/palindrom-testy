#!/bin/bash
i=0

for t in 1 2 3 7 10; do
    for w in 1 2 4 7 50; do
        for k in 1 2 4 26 50; do
            mkdir -p "wyniki/${w}x${k}"
            echo "testowanie -DWIERSZE=${w} -DKOLUMNY=${k} -DRODZAJE=${t}"
            gcc @opcje -DWIERSZE=${w} -DKOLUMNY=${k} -DRODZAJE=${t} main.c -o program
            args=$(cat "wyniki/${w}x${k}/${t}.arg")
            cat "wyniki/${w}x${k}/${t}.in" | valgrind --leak-check=full -q --error-exitcode=1 ./program ${args} > "wyniki/${w}x${k}/${t}.1.out"
            if [[ "$?" -ne 0 ]] ; then
                echo -e "\033[0;31mBłąd wykonania\033[0m"
                exit 1
            fi
            diff "wyniki/${w}x${k}/${t}.out" "wyniki/${w}x${k}/${t}.1.out"
            if [[ "$?" -ne 0 ]] ; then
                echo -e "\033[0;31mInny wynik\033[0m"
                exit 1
            fi
            ((i++))
        done
    done
done

echo -e "\033[0;32m$i testow OK\033[0m"
