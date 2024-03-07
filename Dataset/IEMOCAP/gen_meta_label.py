import os
import numpy as np
import json
import random
from pathlib import Path
import re
import sys
import io
import chardet
import codecs

IEMOCAP_DIR = Path(sys.argv[1])
BOM = '\ufeff'
print ('Generating metalabels...')
metalabel = {}
for i in range(5):
    sess = i + 1
    label_dir = IEMOCAP_DIR / f"Session{sess}" / "dialog" / "EmoEvaluation"
    for labelfile in label_dir.rglob('*[!_].txt'):
        # bytes = min(32, os.path.getsize(labelfile))
        #raw = open(labelfile, 'rb').read(bytes)
        #if raw.startswith(codecs.BOM_UTF8):
        #    encoding = 'utf-8-sig'
        #else:
        #    result = chardet.detect(raw)
        #    encoding = result['encoding']
        encoding = 'windows-1252'#'utf-8-sig'
        with open(labelfile, 'r',encoding=encoding) as f:
            for line in f.readlines():
                m = re.match(r".*(Ses.*)\t(.*)\t.*", line)
                if m:
                    name, label = m.groups()
                    metalabel[name+'.wav'] = label
with open(f'metalabel.json', 'w') as f:
    json.dump(metalabel, f, indent=4)
