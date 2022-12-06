#!/bin/bash
i=0

for t in 1 2 3 7 10; do
    for w in 1 2 4 7 50; do
        for k in 1 2 4 26 50; do
            mkdir -p "wyniki/${w}x${k}"
            echo "generowanie -DWIERSZE=${w} -DKOLUMNY=${k} -DRODZAJE=${t}"
            gcc @opcje -DWIERSZE=${w} -DKOLUMNY=${k} -DRODZAJE=${t} main.c -o program
            python3 gen.py $w $k $t
            if [[ "$?" -ne 0 ]] ; then
                exit 1
            fi
            ((i++))
        done
    done
done

echo -e "\033[0;32m$i testow OK"
