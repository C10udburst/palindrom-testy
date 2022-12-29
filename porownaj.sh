#!/bin/bash
echo -e "Odpalic z valgrind? \033[1m(w chuj wolno)\033[0m"
echo -n "[T]ak/[N]ie "
read yn
case $yn in
    T*|t*|Y*|y*|1 ) valgrind=1;;
    * ) valgrind=0;;
esac
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
