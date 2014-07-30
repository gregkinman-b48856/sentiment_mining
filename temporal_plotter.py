"""
Greg Kinman - B48856
Freescale Semiconductor, Inc.

temporal_plotter.py

Explores temporal relationships between frequencies of sentiments.
"""

import csv, matplotlib.pyplot as plt
from datetime import datetime
from collections import defaultdict

groups = {}
for i in range(5):
    score_class = []
    with open("value_" + str(i) + ".csv", "rb") as f:
        reader = csv.reader(f)
        for row in reader:
            score_class.append(row)
    groups[i] = score_class

plt.figure()
i = 0
colors = ["#FF0000", "#FF9900", "#FFFFFF", "#0066FF", "#00FF00"]
sentiments = ["Very Negative", "Negative", "Neutral", "Positive", "Very Positive"]
for group in groups:
    frequencies = defaultdict(int)
    title_row = True
    for snippet in groups[group]:
        if title_row:
            title_row = False
            continue
        date = datetime.strptime(str(snippet[3]) + " " + str(snippet[4]), "%m %Y")
        frequencies[date] += 1
    plt.plot_date(frequencies.keys(), frequencies.values(), color = colors[i], label = sentiments[i])
    i += 1
    title_row = True
plt.legend(loc = 2)
plt.xlabel("Month of Writing")
plt.ylabel("Frequency")
plt.title("Frequency of Writing of Sentiment Scores on Element14")
plt.show()
