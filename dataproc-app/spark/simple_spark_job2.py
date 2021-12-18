#!/usr/bin/python3
# -*- coding: utf-8 -*-

import pyspark


def main():
    sc = pyspark.SparkContext()
    rdd = sc.parallelize(["Hello,", "world!", "dog", "elephant", "panther"])
    words = sorted(rdd.collect())
    print(words)

if __name__ == "__main__":
    main()
