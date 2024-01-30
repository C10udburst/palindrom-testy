# Jak odpalić testy

Połączyć się zdalnie z labami: https://lk.mimuw.edu.pl/pl/praca-zdalna/ssh

## [SameGame](https://github.com/C10udburst/wdp-testy/tree/samegame)
```bash
git clone -b samegame https://github.com/C10udburst/wdp-testy.git
cd wdp-testy
cp SCIEZKA/DO/KODU.c main.c
bash ./porownaj.sh
```

## [Palindrom](https://github.com/C10udburst/wdp-testy/tree/palindrom)
```bash
git clone -b palindrom https://github.com/C10udburst/wdp-testy.git
cd wdp-testy
cp SCIEZKA/DO/KODU.c main.c
bash ./porownaj.sh
```

## [Życie](https://github.com/C10udburst/wdp-testy/tree/life)
```bash
git clone -b life https://github.com/C10udburst/wdp-testy.git
cd wdp-testy
cp SCIEZKA/DO/KODU.c main.c
bash ./porownaj.sh
```

## [PW-Lockfree](https://github.com/C10udburst/wdp-testy/tree/pw-lockfree)
```bash
git clone https://github.com/C10udburst/uw-testy.git -b pw-lockfree
cp SCIEZKA/DO/PROJEKTU/*.{h,c} ./uw-testy/
cd uw-testy
cmake .
make
./tester
```
