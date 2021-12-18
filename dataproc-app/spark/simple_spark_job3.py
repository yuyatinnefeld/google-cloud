#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
import pyspark


def main():
    print("PYTHON VERSION: ", sys.version)
    parameter_list = sys.argv

    try:
        for p in parameter_list:
            print(p)
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
