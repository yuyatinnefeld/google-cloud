#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
import pyspark
import logging
import argparse

from pyspark.sql import SparkSession


def arg_parser():
    """
    Recives GCP operation arguments and prints these

    Example:
        python spark/simple_spark_job5.py source_bucket=app-bucket, \
            source_format=json, \
            destination=bigquery, \
            destination_name="dataset_table_123", \
            opt_params="debugg=true model=RL data_set=71893271 x=200 y=100"

    """
    print("PYTHON VERSION: ", sys.version)
    print("ALL ARGUMENTS: ", sys.argv)

    main_parser = argparse.ArgumentParser()

    try:
        # main parameter parser
        main_parser.add_argument('source_bucket', type=str, help='the name of GCP source bucket')
        main_parser.add_argument('source_format', type=str, help='the format of source file')
        main_parser.add_argument('destination', type=str, help='the name of destination service')
        main_parser.add_argument('destination_name', type=str, help='the name of target location')
        main_parser.add_argument('opt_params', type=str, help='the optional parameters')

        # Execute the main parse_args() method
        args = main_parser.parse_args()
        source_bucket = args.source_bucket
        source_format = args.source_format
        destination = args.destination
        destination_name = args.destination_name
        opt_params = args.opt_params
        print(source_bucket)
        print(source_format)
        print(destination)
        print(destination_name)
        print(opt_params)

        # Execute the sub parse_args() method
        opt_params = opt_params.split(" ")
        debugg_mode = opt_params[0]
        ml_model = opt_params[1]
        data_set = opt_params[2]
        x = opt_params[3]
        print(debugg_mode)
        print(ml_model)
        print(data_set)

    except Exception as e:
        print(e)


if __name__ == "__main__":
    logger = logging.getLogger("py4j")    
    logger.setLevel(logging.WARN)
    spark = SparkSession.builder.master("local[2]").appName("Engine").getOrCreate()
    
    arg_parser()
    
    spark.stop()


