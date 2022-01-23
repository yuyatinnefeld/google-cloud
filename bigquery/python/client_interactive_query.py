from google.cloud import bigquery


client = bigquery.Client()

def interactive_query(my_query: str) -> str:
    query_job = client.query(
        my_query,
        job_config=bigquery.QueryJobConfig(
            labels={"job-type": "analyze"}, maximum_bytes_billed=100000000
        ),
        job_id_prefix="datascience_job_123_",
    )

    print("The query data:")
    rows = query_job.result()  # Waits for query to finish
    for row in rows:
        #print(row)
        print("Col1: {} - Col2: {}".format(row.day, row.month))

    print("Started job: {}".format(query_job.job_id))
    return query_job.job_id