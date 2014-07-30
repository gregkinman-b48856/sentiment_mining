"""
Greg Kinman - B48856
Freescale Semiconductor, Inc.

temporal_plotter.py

Explores temporal relationships between frequencies of sentiments.
"""

import csv, matplotlib.pyplot as plt
from datetime import datetime
from collections import defaultdict

def main():

    """
    Main function.
    """

    groups = grouper()

    plotter(groups)

def grouper():

    """
    Reads the data from each score class and groups it.

    Output:
    1. groups:     dict of ints mapped to lists of strs and ints: the snippets grouped by sentiment score
    """

    groups = {}
    for i in range(5):
        score_class = []
        with open("value_" + str(i) + ".csv", "rb") as f:
            reader = csv.reader(f)
            for row in reader:
                score_class.append(row)
        groups[i] = score_class

    return groups

def plotter(groups):

    """
    Plots the frequency of each group over time.

    Input:
    1. groups:     dict of ints mapped to lists of strs and ints: the snippets grouped by sentiment score
    """

    plt.figure()
    i = 0
    colors = ["#FF0000", "#FF9900", "#FFFFFF", "#0066FF", "#00FF00"]
    sentiments = ["Very Negative", "Negative", "Neutral", "Positive", "Very Positive"]
    for group in groups:
        frequencies = defaultdict(int)
        title_row = True
        for snippet in groups[group]:
            # Skips the title row, since it has no data.
            if title_row:
                title_row = False
                continue
            # Counts the occurrences in each month.
            date = datetime.strptime(str(snippet[3]) + " " + str(snippet[4]), "%m %Y")
            frequencies[date] += 1
        plt.plot_date(frequencies.keys(), frequencies.values(), color = colors[i], label = sentiments[i])
        i += 1
        title_row = True
    plt.legend(loc = 2)
    plt.xlabel("Month of Writing")
    plt.ylabel("Frequency")
    plt.title("Frequency of Writing of Sentiment Scores on Element14")
    plt.savefig("frequencies.pdf")

if __name__ == "__main__":
    main()
