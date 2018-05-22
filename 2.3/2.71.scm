#lang sicp
;Exercise 2.71.  Suppose we have a Huffman tree for an alphabet of n symbols, and that the relative frequencies of the symbols are 1, 2, 4, ..., 2^(n-1). Sketch the tree for n=5; for n=10. In such a tree (for general n) how many bits are required to encode the most frequent symbol? the least frequent symbol?

;As seen in the corresponding sketchs, 1 bit is required to encode the most frequent symbol, and n-1 bits are required to encode the least frequent symbol.