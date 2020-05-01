#!/usr/bin/env python3
import json
import gzip
import sys

if __name__ == "__main__":
  assert len(sys.argv) >= 2, "usage: <script> <gzipped path> <n>"
  n = int(sys.argv[2]) if len(sys.argv) == 3 else -1
  with gzip.open(sys.argv[1], 'r') as g:
    for i,l in enumerate(g):
      if i >= n > 0:
        break
      sys.stdout.write(json.dumps(eval(l)) + '\n')

