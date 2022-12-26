name = input("https://playgameoflife.com/lexicon/")

import requests
r = requests.get(f"https://playgameoflife.com/lexicon/data/{name}.json")
r = r.json()

rows = []

for line in r['pattern'].split("\n"):
    rows.append([])
    for i, c in enumerate(line):
        if c == 'O':
            rows[-1].append(i+1)
            
for i,row in enumerate(rows):
    if len(row) < 1:
        continue
    print(f"/{i+1}", end='')
    for col in row:
        print(f" {col}", end='')
    print()
print("/")