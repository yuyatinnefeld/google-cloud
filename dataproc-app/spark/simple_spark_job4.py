#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
import pyspark


def main():
    parameter_list = sys.argv
    print("PYTHON VERSION: ", sys.version)

    try:
        job_name=parameter_list[0]
        source_bucket=parameter_list[1]
        source_format=parameter_list[2]
        destination=parameter_list[3]
        destination_name=parameter_list[3]
        
        print("JOB_NAME:", job_name)
        print("SOURCE_BUCKET:", source_bucket)
        print("SOURCE_FORMAT:", source_format)
        print("DESTINATION:", destination)
        print("DESTINATION_NAME:", destination_name)
    except Exception as e:
        print(e)




if __name__ == "__main__":
    main()


