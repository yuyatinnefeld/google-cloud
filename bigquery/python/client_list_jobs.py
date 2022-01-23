from google.cloud import bigquery
import datetime


client = bigquery.Client()

def status_print(job_id, location):
    job = client.get_job(job_id, location=location)

    print("Details for job {} running in {}:".format(job_id, location))
    print(
        "\tType: {}\n\tState: {}\n\tCreated: {}".format(
            job.job_type, job.state, job.created
        )
    )


def list_jobs(credentials, project_id, job_results_count):
    client = bigquery.Client(project=project_id, credentials=credentials)

    print("Last {} jobs run by all users:".format(job_results_count))

    sum_bytes_billed = 0
    sum_bytes_processed = 0

    for idx, job in enumerate(client.list_jobs(max_results=job_results_count, all_users=True)):
        #https://googleapis.dev/python/bigquery/latest/generated/google.cloud.bigquery.job.QueryJob.html

        print("#######################################")
        print("Job: {}".format(idx))
        print("Job ID: {}".format(job.job_id))
        print("Job Type: {}".format(job.job_type))
        print("Labels: {}".format(job.labels))
        print("State: {}".format(job.state))
        print("Created: {}".format(job.created))
        print("Started: {}".format(job.started))
        print("Ended: {}".format(job.ended))
        print("User: {}".format(job.user_email))

        if(job.job_type == 'query'):
            print("Estimated Bytes Processed: {}".format(job.estimated_bytes_processed))
            print("Total Bytes Billed: {}".format(job.total_bytes_billed))
            print("Total Bytes Processed: {}".format(job.total_bytes_processed))
            print("Query: {}".format(job.query))

            if(isinstance(job.total_bytes_billed, int) and isinstance(job.total_bytes_processed, int)):
                sum_bytes_billed += job.total_bytes_billed
                sum_bytes_processed += job.total_bytes_processed

        if(job.job_type == 'load'):
            print("Input File Bytes: {}".format(job.input_file_bytes))
            print("Input File: {}".format(job.input_files))
            print("Destination Table: {}".format(job.destination))
            print("Schema: {}".format(job.schema))


    print("\n 🤖 ########## Query Bytes Consume ########## 🤖")
    print("Bytes Billed: {}".format(sum_bytes_billed))
    print("Bytes Processed: {}".format(sum_bytes_processed))