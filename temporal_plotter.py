"""
Greg Kinman - B48856
Freescale Semiconductor, Inc.

temporal_plotter.py

Explores temporal relationships between frequencies of sentiments.
"""

import csv, matplotlib.pyplot as plt
from collections import defaultdict

groups = {}
for i in range(5):
    score_class = []
    with open("value_" + str(i) + ".csv", "rb") as f:
        reader = csv.reader(f)
        for row in reader:
            score_class.append(row)
    groups[i] = score_class

for group in groups:
    years = defaultdict(list)
    for snippet in groups[group]:
        years[snippet[4]].append(snippet)
