import json
import gzip
import sys

if __name__ == "__main__":
  with gzip.open(sys.argv[1], 'r') as g:
    for i,l in enumerate(g):
      d = eval(l)
      if "imUrl" in d:
          print(d["imUrl"], d["asin"])

