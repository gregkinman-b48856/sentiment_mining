Sentiment Mining
===

This is the repository for the text mining phase of the sentiment analysis project at Freescale. The first phase of the project can be found at [this repository](https://github.com/gregkinman-b48856/sentiment_analysis).

Most of the analysis is done in R, with the `tm` package being the main tool, although some plotting is done in Python using matplotlib.

Some of the main analyses that were performed or that could be performed are the following:

- Plotting frequency of occurrence of negative, neutral, and positive scores versus time. The very negative and very positive scores were not numerous enough to glean any meaning from them.
- Word clustering analysis: both text output and tree output (sometimes also called a "dendrogram").
- Most frequent terms: text output and bar plots.
- Network analysis: a node-edge visual representation of what words are associated with others and the strength of these associations.
- Word associations: numerical values.

This is a pretty open-ended codebase; a lot of manual exploration needs to be done with any dataset of this form. Every dataset is different, so the analyst needs to play with different analysis and visualization methods to try to see meaning in the data.

Thanks to RDataMining for tutorials with the `tm` package.
