import sys, unicodedata

INVIS = [
    "​", "‌", "‍", "⁠", "﻿", "­",
    " ", " ", " ", " ",
    "‪", "‫", "‬", "‭", "‮",
    "⁦", "⁧", "⁨", "⁩",
]

for path in sys.argv[1:]:
    src = open(path, encoding="utf-8").read()
    found = {}
    for ch in INVIS:
        n = src.count(ch)
        if n:
            found[f"U+{ord(ch):04X} {unicodedata.name(ch, '?')}"] = n
    clean = src
    for ch in INVIS:
        clean = clean.replace(ch, "")
    if clean != src:
        open(path, "w", encoding="utf-8").write(clean)
    print(f"{path}: {found or 'nada invisivel'} | NBSP mantidos: {clean.count(chr(0xA0))} | bytes: {len(clean)}")
