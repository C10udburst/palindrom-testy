from subprocess import *
import requests
from bs4 import BeautifulSoup
import os
import re

BLACKLIST = ["spacefiller"]

def generate_start(name):
    stdin = ""
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
        stdin += f"/{i+1}"
        for col in row:
            stdin += f" {col}"
        stdin += "\n"
    stdin += "/\n"
    
    return stdin

def fetch_name_list():
    r = requests.get("https://playgameoflife.com/list.html")
    soup = BeautifulSoup(r.text)
    names = set()
    for a in soup.select('section a[href^="/lexicon"]'):
        names.add(a['href'].split("/")[-1])
    return list(names)
    
for name in fetch_name_list():
    if name in BLACKLIST:
        continue
    try:
        safe_name = re.sub(r"[^a-zA-Z0-9_-]","_",name)
        print(f"generating: {name}")
        stdin = generate_start(name)
        stdin += "\n\n5000\n2 2\n0\n.\n"
        proc = run(["./main"], capture_output=True, input=stdin.encode('utf-8'))
        if proc.returncode != 0:
            print(proc.stderr.decode())
            break
        os.system(f"mkdir -p ./wyniki/{safe_name}/")
        open(f"./wyniki/{safe_name}/in", "w+", encoding='utf-8').write(stdin)
        open(f"./wyniki/{safe_name}/out", "w+b").write(proc.stdout)
        open(f"./wyniki/{safe_name}/name", "w+").write(name)
    except Exception as ex:
        print(f"{name}: {ex}")
