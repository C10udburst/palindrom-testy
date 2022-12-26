#!/bin/bash
gcc @opt main.c -o main
i=0
for d in ./wyniki/*; do
    cd $d
    echo "Testowanie: $d"
    cat in | valgrind --leak-check=full -q --error-exitcode=1 ../../main > out2
    if [[ "$?" -ne 0 ]] ; then
        echo -e "\033[0;31mBłąd wykonania\033[0m"
        if [ -f "name" ]; then
            echo "Przykład: https://playgameoflife.com/lexicon/$(cat name)"
        fi
        exit 1
    fi
    diff out out2
    if [[ "$?" -ne 0 ]] ; then
        echo -e "\033[0;31mInny wynik\033[0m"
        if [ -f "name" ]; then
            echo "Przykład: https://playgameoflife.com/lexicon/$(cat name)"
        fi
        exit 1
    fi
    ((i++))
    cd ../..
done

echo -e "\033[0;32m$i testow OK\033[0m"
