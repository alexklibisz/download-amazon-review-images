#!/usr/bin/env python3
import json
import gzip
import sys

if __name__ == "__main__":
  assert len(sys.argv) == 4, "usage: <script> <gzipped path> <skip n> <read n>"
  skip = int(sys.argv[2])
  n = int(sys.argv[3])
  with gzip.open(sys.argv[1], 'r') as g:
    for i,l in enumerate(g):
      if i < skip:
        continue
      if i >= n + skip > 0:
        break
      d = eval(l)
      if "imUrl" in d and d["imUrl"].endswith("jpg"):
        print(d["imUrl"], d["asin"])
