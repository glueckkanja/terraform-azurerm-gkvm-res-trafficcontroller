import os
import json
import requests

def is_protected(file_path: str) -> bool:
    try:
        return any(os.path.samefile(file_path, pf) for pf in PROTECTED_FILES)
    except FileNotFoundError:
        return False

def copy_from_url(source: str, target: str) -> None:
    if is_protected(target):
        print(f"Skipping protected or missing file: {target}")
        return

    response = requests.get(source)
    if response.status_code == 200:
        with open(target, 'wb') as f:
            f.write(response.content)
    else:
        print(f"Failed to download {source}: {response.status_code}")

with open('files.json', 'r') as f:
    data = json.load(f)

# these are protected files that should not be overwritten
pf = data['protected']
pf.append(__file__)

PROTECTED_FILES = [p if os.path.isfile(p) else '' for p in set(pf)]

for file in data['copy']:
    copy_from_url(file['source'], file['target'])
