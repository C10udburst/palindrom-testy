#!/bin/bash
valgrind=0
dialog --yesno "Odpalic z valgrindem?\n(W chuj wolno, ale dziala na students)\n\nBez valgrinda trzeba polaczyc sie z ktoryms z labowych komputerow." 20 60 && valgrind=1
clear
if [[ "$valgrind" -ne 0 ]] ; then
    gcc @opt main.c -o main
else
    gcc @opt -fsanitize=leak main.c -o main
fi
i=0
echo "Valgrind: $valgrind"
for d in ./wyniki/*; do
    cd $d
    echo "Testowanie: $d"
    if [[ "$valgrind" -ne 0 ]] ; then
        cat in | valgrind --leak-check=full -q --error-exitcode=1 ../../main > out2
    else
        cat in | ../../main > out2
    fi
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
